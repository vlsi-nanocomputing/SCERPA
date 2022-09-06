<?xml version="1.0" encoding="UTF-8"?>
<!--File describing the layout of a QCA circuit-->
<qcalayout>
    <technologies>
        <settings tech="MolQCA">
            <property name="Layoutwidth" value="8"/>
            <property name="CZSequence" value="4"/>
            <property name="layersEnabled" value="false"/>
            <property name="Intermolecular Distance" value="1000"/>
            <property name="PhaseNumber" value="3"/>
            <property name="Layoutheight" value="10"/>
        </settings>
    </technologies>
    <components>
        <item tech="MolQCA" name="Bisferrocene"/>
    </components>
    <layout>
        <pin tech="MolQCA" name="L" direction="1" id="1" angle="90" x="4" y="10" layer="0"/>
        <pin tech="MolQCA" name="H" direction="1" id="2" angle="270" x="4" y="0" layer="0"/>
        <pin tech="MolQCA" name="R" direction="1" id="3" x="8" y="5" layer="0"/>
        <item comp="0" id="4" x="7" y="5" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="5" x="6" y="5" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="6" x="5" y="5" layer="0">
            <property name="phase" value="2"/>
        </item>
        <pin tech="MolQCA" name="Dr1" direction="0" id="7" x="0" y="5" layer="0"/>
        <item comp="0" id="8" x="1" y="5" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="9" x="2" y="5" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="10" x="3" y="5" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="11" x="4" y="5" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="12" x="4" y="4" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="13" x="4" y="3" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="14" x="4" y="2" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="15" x="4" y="1" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="16" x="4" y="6" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="17" x="4" y="7" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="18" x="4" y="8" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="19" x="4" y="9" layer="0">
            <property name="phase" value="2"/>
        </item>
    </layout>
</qcalayout>
