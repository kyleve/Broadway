import SwiftUI
import BroadwayUI
import BroadwayCore

struct ContentView: View {

    @State private var currentTheme: BroadwayTheme = .light

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: currentTheme.spacing.lg) {
                    themePicker
                    colorSection
                    typographySection
                    buttonSection
                    cardSection
                }
                .padding(currentTheme.spacing.md)
            }
            .background(currentTheme.colors.background)
            .navigationTitle("Broadway Catalog")
        }
        .broadwayTheme(currentTheme)
    }

    // MARK: - Sections

    private var themePicker: some View {
        BroadwayCard {
            VStack(alignment: .leading, spacing: currentTheme.spacing.sm) {
                BroadwayText("Theme", role: .titleMedium)
                Picker("Theme", selection: $currentTheme) {
                    Text("Light").tag(BroadwayTheme.light)
                    Text("Dark").tag(BroadwayTheme.dark)
                }
                .pickerStyle(.segmented)
            }
        }
    }

    private var colorSection: some View {
        BroadwayCard {
            VStack(alignment: .leading, spacing: currentTheme.spacing.sm) {
                BroadwayText("Color Tokens", role: .titleMedium)

                colorSwatch("Primary", color: currentTheme.colors.primary)
                colorSwatch("Secondary", color: currentTheme.colors.secondary)
                colorSwatch("Background", color: currentTheme.colors.background)
                colorSwatch("Surface", color: currentTheme.colors.surface)
                colorSwatch("Error", color: currentTheme.colors.error)
                colorSwatch("Outline", color: currentTheme.colors.outline)
            }
        }
    }

    private var typographySection: some View {
        BroadwayCard {
            VStack(alignment: .leading, spacing: currentTheme.spacing.sm) {
                BroadwayText("Typography Tokens", role: .titleMedium)
                BroadwayText("Display Large", role: .displayLarge)
                BroadwayText("Title Large", role: .titleLarge)
                BroadwayText("Title Medium", role: .titleMedium)
                BroadwayText("Body Large", role: .bodyLarge)
                BroadwayText("Body Medium", role: .bodyMedium)
                BroadwayText("Caption", role: .caption)
            }
        }
    }

    private var buttonSection: some View {
        BroadwayCard {
            VStack(alignment: .leading, spacing: currentTheme.spacing.sm) {
                BroadwayText("Buttons", role: .titleMedium)
                BroadwayButton("Primary Button", style: .primary) {}
                BroadwayButton("Secondary Button", style: .secondary) {}
            }
        }
    }

    private var cardSection: some View {
        BroadwayCard {
            VStack(alignment: .leading, spacing: currentTheme.spacing.sm) {
                BroadwayText("Cards", role: .titleMedium)
                BroadwayText(
                    "This entire gallery is built with BroadwayCard. "
                    + "Cards provide an elevated surface with consistent "
                    + "padding, corner radius, and outline from the theme.",
                    role: .bodyMedium
                )
            }
        }
    }

    // MARK: - Helpers

    private func colorSwatch(_ label: String, color: Color) -> some View {
        HStack(spacing: currentTheme.spacing.sm) {
            RoundedRectangle(cornerRadius: currentTheme.shape.cornerRadiusSmall)
                .fill(color)
                .frame(width: 32, height: 32)
                .overlay(
                    RoundedRectangle(cornerRadius: currentTheme.shape.cornerRadiusSmall)
                        .strokeBorder(currentTheme.colors.outline, lineWidth: currentTheme.shape.borderWidth)
                )
            BroadwayText(label, role: .bodyMedium)
        }
    }
}

#Preview("Light") {
    ContentView()
}
