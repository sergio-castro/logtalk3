package org.logtalk.parser

import com.intellij.psi.PsiElement
import org.logtalk.intellij.psi.LogtalkTypes
import org.logtalk.intellij.psi.decorator.AtomDecorator
import spock.lang.Specification

import static org.logtalk.intellij.psi.decorator.AtomDecorator.atomDecorator

class StandAloneParserSpec extends Specification {

    def "parse sentence"() {
        when:
        PsiElement sentence = StandAloneParser.parseSentence("x")
        then:
        sentence.getNode().getElementType().equals(LogtalkTypes.SENTENCE)
    }

    def "parse atom"() {
        when:
        AtomDecorator unquotedStom = atomDecorator(StandAloneParser.parseAtom("x"))
        AtomDecorator quotedAtom = atomDecorator(StandAloneParser.parseAtom("'x'"))
        then:
        !unquotedStom.isQuoted()
        quotedAtom.isQuoted()
    }
}
