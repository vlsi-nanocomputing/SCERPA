<?xml version="1.0" encoding="UTF-8"?>
<!--File describing the layout of a QCA circuit-->
<qcalayout>
    <technologies>
        <settings tech="MolQCA">
            <property name="layersEnabled" value="false"/>
            <property name="CZSequence" value="4"/>
            <property name="Intermolecular Distance" value="1000"/>
            <property name="Layoutwidth" value="7"/>
            <property name="Layoutheight" value="7"/>
            <property name="PhaseNumber" value="3"/>
        </settings>
    </technologies>
    <components>
        <item tech="MolQCA" name="Bisferrocene"/>
    </components>
    <layout>
        <pin tech="MolQCA" name="o2" direction="1" id="1" angle="270" x="6" y="0" layer="0"/>
        <pin tech="MolQCA" name="o" direction="1" id="2" angle="270" x="5" y="0" layer="0"/>
        <item comp="0" id="3" x="1" y="5" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="4" x="2" y="5" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="5" x="3" y="5" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="6" x="4" y="5" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="7" x="5" y="4" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="8" x="5" y="3" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="9" x="5" y="2" layer="0">
            <property name="phase" value="1"/>
        </item>
        <pin tech="MolQCA" name="Dr1" direction="0" id="10" x="0" y="5" layer="0"/>
        <item comp="0" id="11" x="5" y="5" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="12" x="5" y="6" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="13" x="5" y="1" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="14" x="6" y="5" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="15" x="1" y="6" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="16" x="2" y="6" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="17" x="3" y="6" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="18" x="4" y="6" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="19" x="6" y="6" layer="0">
            <property name="phase" value="0"/>
        </item>
        <item comp="0" id="20" x="6" y="1" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="21" x="6" y="2" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="22" x="6" y="3" layer="0">
            <property name="phase" value="1"/>
        </item>
        <item comp="0" id="23" x="6" y="4" layer="0">
            <property name="phase" value="1"/>
        </item>
        <pin tech="MolQCA" name="Dr1" direction="0" id="24" x="0" y="6" layer="0"/>
    </layout>
</qcalayout>
