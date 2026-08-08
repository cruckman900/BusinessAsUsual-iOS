import SwiftUI

/// Dynamic form screen renderer - creates/edits data with validation.
/// Matches Android's DynamicFormScreen.
struct DynamicFormScreen: View {
    let spec: FormScreenSpec
    let initialValues: [String: String]
    let onSubmit: ([String: String]) -> Void
    let onCancel: () -> Void
    
    @Environment(\.bauTheme) private var theme
    @State private var formData: [String: String] = [:]
    @State private var errors: [String: String] = [:]
    @State private var isSubmitting = false
    
    init(spec: FormScreenSpec,
         initialValues: [String: String] = [:],
         onSubmit: @escaping ([String: String]) -> Void = { _ in },
         onCancel: @escaping () -> Void = {}) {
        self.spec = spec
        self.initialValues = initialValues
        self.onSubmit = onSubmit
        self.onCancel = onCancel
        self._formData = State(initialValue: initialValues)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(spec.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.onBackground)
                    .padding(.horizontal, 16)
                
                ForEach(spec.sections, id: \.id) { section in
                    formSection(section)
                }
                
                actionButtons
            }
            .padding(.vertical, 16)
        }
        .disabled(isSubmitting)
    }
    
    private func formSection(_ section: FormSection) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title)
                .font(.headline)
                .foregroundColor(theme.onSurface)
                .padding(.horizontal, 16)
            
            VStack(spacing: 16) {
                ForEach(section.fields, id: \.name) { field in
                    formField(field)
                }
            }
            .padding(16)
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    private func formField(_ field: FormField) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(field.label)
                    .font(.subheadline)
                    .foregroundColor(theme.onSurface)
                if field.required {
                    Text("*")
                        .foregroundColor(.red)
                }
            }
            
            switch field.type {
            case FieldTypes.text, FieldTypes.email, FieldTypes.phone, FieldTypes.number:
                textField(field)
            case FieldTypes.select:
                selectField(field)
            case FieldTypes.date:
                dateField(field)
            case FieldTypes.multiselect:
                multiselectField(field)
            default:
                textField(field)
            }
            
            if let error = errors[field.name] {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 2)
            } else if let helpText = field.helpText {
                Text(helpText)
                    .font(.caption)
                    .foregroundColor(theme.onSurface.opacity(0.7))
                    .padding(.top, 2)
            }
        }
    }
    
    private func textField(_ field: FormField) -> some View {
        TextField(field.placeholder ?? "", text: binding(for: field.name))
            .textFieldStyle(.roundedBorder)
            .keyboardType(keyboardType(for: field.type))
            .textContentType(contentType(for: field.type))
            .onChange(of: formData[field.name] ?? "") { newValue in
                validateField(field, value: newValue)
            }
    }
    
    private func selectField(_ field: FormField) -> some View {
        Menu {
            ForEach(field.options, id: \.value) { option in
                Button(option.label) {
                    formData[field.name] = option.value
                    validateField(field, value: option.value)
                }
            }
        } label: {
            HStack {
                Text(selectedLabel(for: field) ?? field.placeholder ?? "Select...")
                    .foregroundColor(selectedLabel(for: field) != nil ? theme.onSurface : theme.onSurface.opacity(0.5))
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(theme.onSurface.opacity(0.5))
            }
            .padding(8)
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
    
    private func dateField(_ field: FormField) -> some View {
        DatePicker(
            "",
            selection: Binding(
                get: { dateFromString(formData[field.name] ?? "") ?? Date() },
                set: { formData[field.name] = dateToString($0) }
            ),
            displayedComponents: .date
        )
        .labelsHidden()
        .onChange(of: formData[field.name] ?? "") { newValue in
            validateField(field, value: newValue)
        }
    }
    
    private func multiselectField(_ field: FormField) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(field.options, id: \.value) { option in
                let isSelected = selectedValues(for: field.name).contains(option.value)
                Button(action: {
                    toggleMultiselect(field: field.name, value: option.value)
                }) {
                    HStack {
                        Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                            .foregroundColor(isSelected ? theme.primary : theme.onSurface.opacity(0.5))
                        Text(option.label)
                            .foregroundColor(theme.onSurface)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 12) {
            if let cancelAction = spec.actions.first(where: { $0.id == "cancel" }) {
                Button(cancelAction.label) {
                    onCancel()
                }
                .buttonStyle(.bauOutlined)
            }
            
            if let submitAction = spec.actions.first(where: { $0.id == "submit" || $0.id == "save" }) {
                Button(action: handleSubmit) {
                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        HStack {
                            IconResolver.resolve(submitAction.icon)
                            Text(submitAction.label)
                        }
                    }
                }
                .buttonStyle(.bauFilled)
                .disabled(!isFormValid || isSubmitting)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    // MARK: - Helper Methods
    
    private func binding(for field: String) -> Binding<String> {
        Binding(
            get: { formData[field] ?? "" },
            set: { formData[field] = $0 }
        )
    }
    
    private func validateField(_ field: FormField, value: String) {
        var error: String?
        
        if field.required && value.trimmingCharacters(in: .whitespaces).isEmpty {
            error = field.validationMessage ?? "\(field.label) is required"
        } else if let minLength = field.minLength, value.count < minLength {
            error = "Minimum \(minLength) characters required"
        } else if let maxLength = field.maxLength, value.count > maxLength {
            error = "Maximum \(maxLength) characters allowed"
        } else if let pattern = field.pattern, !value.isEmpty {
            if let regex = try? NSRegularExpression(pattern: pattern) {
                let range = NSRange(value.startIndex..., in: value)
                if regex.firstMatch(in: value, range: range) == nil {
                    error = field.validationMessage ?? "Invalid format"
                }
            }
        }
        
        if let error = error {
            errors[field.name] = error
        } else {
            errors.removeValue(forKey: field.name)
        }
    }
    
    private func validateForm() {
        errors.removeAll()
        for section in spec.sections {
            for field in section.fields {
                validateField(field, value: formData[field.name] ?? "")
            }
        }
    }
    
    private var isFormValid: Bool {
        validateForm()
        return errors.isEmpty
    }
    
    private func handleSubmit() {
        validateForm()
        guard errors.isEmpty else { return }
        
        isSubmitting = true
        onSubmit(formData)
        // Note: caller should reset isSubmitting or navigate away
    }
    
    private func keyboardType(for fieldType: String) -> UIKeyboardType {
        switch fieldType {
        case FieldTypes.email: return .emailAddress
        case FieldTypes.phone: return .phonePad
        case FieldTypes.number: return .numberPad
        default: return .default
        }
    }
    
    private func contentType(for fieldType: String) -> UITextContentType? {
        switch fieldType {
        case FieldTypes.email: return .emailAddress
        case FieldTypes.phone: return .telephoneNumber
        default: return nil
        }
    }
    
    private func selectedLabel(for field: FormField) -> String? {
        guard let value = formData[field.name] else { return nil }
        return field.options.first(where: { $0.value == value })?.label
    }
    
    private func selectedValues(for field: String) -> [String] {
        (formData[field] ?? "").split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
    }
    
    private func toggleMultiselect(field: String, value: String) {
        var selected = selectedValues(for: field)
        if let index = selected.firstIndex(of: value) {
            selected.remove(at: index)
        } else {
            selected.append(value)
        }
        formData[field] = selected.joined(separator: ",")
    }
    
    private func dateFromString(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: string)
    }
    
    private func dateToString(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: date)
    }
}

#Preview {
    let spec = FormScreenSpec(
        title: "New Employee",
        sections: [
            FormSection(id: "personal", title: "Personal Information", fields: [
                FormField(name: "firstName", label: "First Name", type: FieldTypes.text, required: true, placeholder: "John"),
                FormField(name: "lastName", label: "Last Name", type: FieldTypes.text, required: true, placeholder: "Doe"),
                FormField(name: "email", label: "Email", type: FieldTypes.email, required: true, placeholder: "john.doe@company.com"),
                FormField(name: "phone", label: "Phone", type: FieldTypes.phone, placeholder: "+1 (555) 123-4567")
            ]),
            FormSection(id: "employment", title: "Employment", fields: [
                FormField(name: "title", label: "Job Title", type: FieldTypes.text, required: true),
                FormField(name: "department", label: "Department", type: FieldTypes.select, required: true, options: [
                    SelectOption(value: "eng", label: "Engineering"),
                    SelectOption(value: "product", label: "Product"),
                    SelectOption(value: "design", label: "Design")
                ]),
                FormField(name: "startDate", label: "Start Date", type: FieldTypes.date, required: true)
            ])
        ],
        actions: [
            ScreenAction(id: "cancel", label: "Cancel", icon: "xmark", action: ActionTypes.custom),
            ScreenAction(id: "submit", label: "Save", icon: "checkmark", action: ActionTypes.apiCall)
        ],
        validation: FormValidation()
    )
    
    return DynamicFormScreen(spec: spec, initialValues: [:])
        .environment(\.bauTheme, ThemeRegistry.resolve(name: "bau", dark: false))
}
