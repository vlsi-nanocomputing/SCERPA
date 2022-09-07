<?xml version="1.0" encoding="UTF-8"?>
<!--File describing the layout of a QCA circuit-->
<qcalayout>
    <technologies>
        <settings tech="MolQCA">
            <property name="Layoutheight" value="7"/>
            <property name="PhaseNumber" value="3"/>
            <property name="layersEnabled" value="false"/>
            <property name="Intermolecular Distance" value="1000"/>
            <property name="CZSequence" value="4"/>
            <property name="Layoutwidth" value="7"/>
        </settings>
    </technologies>
    <components>
        <item tech="MolQCA" name="Bisferrocene"/>
    </components>
    <layout>
        <pin tech="MolQCA" name="ol" direction="1" id="1" x="7" y="4" layer="0"/>
        <pin tech="MolQCA" name="oh" direction="1" id="2" x="7" y="3" layer="0"/>
        <item comp="0" id="3" x="1" y="3" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="4" x="3" y="1" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="5" x="3" y="5" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="6" x="3" y="4" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="7" x="5" y="3" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="8" x="6" y="3" layer="0">
            <property name="phase" value="2"/>
        </item>
        <item comp="0" id="9" x="6" y="4" layer="0">
            <property name="phase" value="2"/>
        </item>
        <pin tech="MolQCA" name="Dr1" direction="0" id="10" x="3" y="0" layer="0"/>
        <pin tech="MolQCA" name="Dr2" direction="0" id="11" x="0" y="3" layer="0"/>
        <pin tech="MolQCA" name="Dr3" direction="0" id="12" x="4" y="7" layer="0"/>
        <item comp="0" id="13" x="4" y="1" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="14" x="3" y="2" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="15" x="4" y="2" layer="0">
            <property name="phase" value="0"/>
        </item>
        <pin tech="MolQCA" name="Dr1" direction="0" id="16" x="4" y="0" layer="0"/>
        <item comp="0" id="17" x="2" y="3" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="18" x="2" y="4" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="19" x="1" y="4" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="20" x="4" y="5" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="21" x="4" y="6" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="22" x="3" y="6" layer="0">
            <property name="phase" value="0"/>
        </item>
        <pin tech="MolQCA" name="Dr3" direction="0" id="23" x="3" y="7" layer="0"/>
        <item comp="0" id="24" x="3" y="3" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="25" x="4" y="3" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="26" x="4" y="4" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="27" x="5" y="4" layer="0">
            <property name="phase" value="2"/>
        </item>
        <pin tech="MolQCA" name="Dr2" direction="0" id="28" x="0" y="4" layer="0"/>
    </layout>
</qcalayout>
