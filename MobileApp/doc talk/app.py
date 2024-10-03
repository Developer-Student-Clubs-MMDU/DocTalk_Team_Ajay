import os

# Define the folder structure
folder_structure = {
    "lib/data/models": ["doctor_model.dart"],
    "lib/data/providers": ["doctor_provider.dart"],
    "lib/data/repositories": ["doctor_repository.dart"],
    "lib/bindings": ["app_bindings.dart"],
    "lib/controllers": ["chatbot_controller.dart", "doctor_controller.dart"],
    "lib/views/home": ["home_page.dart"],
    "lib/views/home/widgets": ["chatbot_card.dart", "doctor_card.dart"],
    "lib/views/chatbot": ["chatbot_page.dart"],
    "lib/views/chatbot/widgets": ["message_bubble.dart", "chat_input.dart"],
    "lib/views/doctor": ["doctor_list_page.dart", "doctor_detail_page.dart"],
    "lib/views/doctor/widgets": ["doctor_info_card.dart", "appointment_button.dart"],
    "lib/views/appointment": ["appointment_confirmation_page.dart"],
    "lib/views/shared": ["custom_button.dart", "custom_dialog.dart"],
    "lib/routes": ["app_routes.dart", "app_pages.dart"],
    "lib/theme": ["app_theme.dart", "app_colors.dart"]
}

# Create directories and files based on the folder structure
for folder, files in folder_structure.items():
    # Create directory
    os.makedirs(folder, exist_ok=True)
    # Create files inside the directory
    for file in files:
        file_path = os.path.join(folder, file)
        with open(file_path, 'w') as f:
            f.write(f"// TODO: Implement {file}")

print("Folder structure and files created successfully!")
