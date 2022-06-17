<?xml version="1.0" encoding="UTF-8"?>
<!--File describing the layout of a QCA circuit-->
<qcalayout>
    <technologies>
        <settings tech="MolQCA">
            <property name="layersEnabled" value="false"/>
            <property name="PhaseNumber" value="3"/>
            <property name="Intermolecular Distance" value="1000"/>
            <property name="Layoutwidth" value="5"/>
            <property name="CZSequence" value="4"/>
            <property name="Layoutheight" value="1"/>
        </settings>
    </technologies>
    <components>
        <item tech="MolQCA" name="Bisferrocene"/>
    </components>
    <layout>
        <item comp="0" id="1" x="4" y="0" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="2" x="3" y="0" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="3" x="1" y="0" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="4" x="2" y="0" layer="0">
            <property name="phase" value="0"/>
        </item>
        <pin tech="MolQCA" name="a" direction="0" id="5" x="0" y="0" layer="0"/>
        <pin tech="MolQCA" name="y" direction="0" id="6" x="5" y="0" layer="0"/>
    </layout>
</qcalayout>
