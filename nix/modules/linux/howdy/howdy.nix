{ ... }: {
  config = {
    environment = { etc = { "howdy/config.ini".source = ./config.ini; }; };

    # Setup pam modules
    system-manager.preActivationAssertions.setup-howdy-pam = {
      enable = true;
      script = ''
        pam_files=(
          "/etc/pam.d/login"
          "/etc/pam.d/sudo"
        )
        line_to_insert="auth sufficient pam_howdy.so"

        for pam_file in "''${pam_files[@]}"; do
          # Ensure the PAM file exists
          touch "$pam_file"

          # Check if the line already exists to avoid duplicates
          if ! grep -Fx "$line_to_insert" "$pam_file"; then
              # Create a temporary file with the new line
              echo "$line_to_insert" > /tmp/pam_temp
              # Append the existing content of the PAM file
              cat "$pam_file" >> /tmp/pam_temp
              # Replace the original PAM file
              mv /tmp/pam_temp "$pam_file"
          fi
        done
      '';
    };
  };
}
