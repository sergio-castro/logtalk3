package org.logtalk.parser

import com.intellij.psi.PsiElement
import org.logtalk.intellij.psi.decorator.OperationView
import org.logtalk.parser.StandAloneParser
import spock.lang.Specification

import static org.logtalk.intellij.psi.decorator.ExtendedPsiView.getExtendedPsiView
import static org.logtalk.parser.TestParserHelper.init

class ExtendedViewSpec extends Specification {

    def "operation view"() {
        setup:
        PsiElement termNode = StandAloneParser.parseTerm("a,b,c")
        PsiElement operationNode = termNode.getFirstChild()
        init(operationNode)

        when:
        OperationView operationView = getExtendedPsiView(operationNode.getFirstChild()).get().operationView()
        OperationView root = operationView.getRoot()

        then:
        root.getSentenceCorrectness().isOk()
        !root.isSyntaxError()
        root.isOperator()
        root.getText() == ","

        !root.getLeftArgument().get().isSyntaxError()
        !root.getLeftArgument().get().isOperator()
        root.getLeftArgument().get().getText() == "a"

        !root.getRightArgument().get().isSyntaxError()
        root.getRightArgument().get().isOperator()
        root.getRightArgument().get().getText() == ","

        !root.getRightArgument().get().getLeftArgument().get().isSyntaxError()
        !root.getRightArgument().get().getLeftArgument().get().isOperator()
        root.getRightArgument().get().getLeftArgument().get().getText() == "b"

        !root.getRightArgument().get().getRightArgument().get().isSyntaxError()
        !root.getRightArgument().get().getRightArgument().get().isOperator()
        root.getRightArgument().get().getRightArgument().get().getText() == "c"
    }


    def "operation view with spaces"() {
        setup:
        PsiElement termNode = StandAloneParser.parseTerm("a , b")
        PsiElement operationNode = termNode.getFirstChild()
        init(operationNode)

        when:
        OperationView operationView = getExtendedPsiView(operationNode.getFirstChild()).get().operationView()
        OperationView root = operationView.getRoot()

        then:
        root.getSentenceCorrectness().isOk()
    }

    def "syntax error"() {
        setup:
        PsiElement termNode = StandAloneParser.parseTerm("a,")
        PsiElement operationNode = termNode.getFirstChild()
        init(operationNode)

        when:
        OperationView operationView = getExtendedPsiView(operationNode.getFirstChild()).get().operationView()
        OperationView root = operationView.getRoot()

        then:
        !root.getSentenceCorrectness().isOk()
    }

}
