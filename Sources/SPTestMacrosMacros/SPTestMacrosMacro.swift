import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SPAssertMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        return "try SPAssert(\(argument), description: \(literal: argument.description))"
    }
}

public struct SPUnwrapMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        return "try SPUnwrap(\(argument), description: \(literal: argument.description))"
    }
}

public struct SPTestPlanMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let body = node.argumentList.last?.expression.as(ClosureExprSyntax.self) ?? node.trailingClosure else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        
        let previewName: String? = if node.argumentList.count == 2, let name = node.argumentList.first?.expression.description {
            "TestPlan - " + name
        } else {
            "TestPlan"
        }

        return """
        #Preview(\(literal: previewName)) {
            TestPlan \(body)
        }
        """
    }
}

@main
struct SPTestMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SPAssertMacro.self,
        SPTestPlanMacro.self,
    ]
}
