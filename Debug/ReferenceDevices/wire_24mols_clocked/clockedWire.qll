<?xml version="1.0" encoding="UTF-8"?>
<!--File describing the layout of a QCA circuit-->
<qcalayout>
    <technologies>
        <settings tech="MolQCA">
            <property name="CZSequence" value="4"/>
            <property name="layersEnabled" value="false"/>
            <property name="Layoutwidth" value="13"/>
            <property name="PhaseNumber" value="3"/>
            <property name="Intermolecular Distance" value="1000"/>
            <property name="Layoutheight" value="1"/>
        </settings>
    </technologies>
    <components>
        <item tech="MolQCA" name="Bisferrocene"/>
    </components>
    <layout>
        <pin tech="MolQCA" name="Dr1" direction="0" id="1" x="0" y="0" layer="0"/>
        <item comp="0" id="2" x="12" y="0" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="3" x="8" y="0" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="4" x="4" y="0" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="5" x="3" y="0" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="6" x="1" y="0" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="7" x="2" y="0" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="8" x="5" y="0" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="9" x="6" y="0" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="10" x="7" y="0" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="11" x="9" y="0" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="12" x="10" y="0" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="13" x="11" y="0" layer="0">
            <property name="phase" value="2"/>
        </item>
        <pin tech="MolQCA" name="y" direction="0" id="14" x="13" y="0" layer="0"/>
    </layout>
</qcalayout>
