/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FASlotName, WindowConstants } from '@ohos/commonconstants';
import { PluginClickInfo, PluginInfo, PluginParseInfo } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const TAG = 'Ctrl.ControlCenterPluginPcModeMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

const HW_SHARE_PANEL_HEIGHT = 376;
const CAST_PANEL_HEIGHT = 398;
const NEAR_LINK_PANEL_HEIGHT = 370;
const EBOOK_PANEL_HEIGHT = 283;
const NOT_DISTURB_PANEL_HEIGHT = 413;
const INDICATOR_PANEL_HEIGHT = 398;
const ACCOUNT_PANEL_HEIGHT = 398;

export class ControlCenterPcModePluginPanelMgr {
  private static mInstance: ControlCenterPcModePluginPanelMgr;

  private controlCenterPanels: PluginInfo[] = [];

  public static getInstance(): ControlCenterPcModePluginPanelMgr {
    if (!ControlCenterPcModePluginPanelMgr.mInstance) {
      ControlCenterPcModePluginPanelMgr.mInstance = new ControlCenterPcModePluginPanelMgr();
    }
    return ControlCenterPcModePluginPanelMgr.mInstance;
  }

  public init(): void {
    let pluginInfo: PluginInfo = new PluginInfo();
    pluginInfo = new PluginInfo();
    pluginInfo.pluginParseInfo = new PluginParseInfo();
    pluginInfo.pluginParseInfo.bundleName = 'com.ohos.instantshare';
    pluginInfo.pluginParseInfo.pluginAbilityName = 'ShareSettingsDialogAbility';
    pluginInfo.pluginParseInfo.clickInfo = new PluginClickInfo();
    pluginInfo.pluginParseInfo.clickInfo.clickType = 'window';
    pluginInfo.pluginParseInfo.clickInfo.abilityName = 'ShareSettingsDialogAbility';
    pluginInfo.pluginParseInfo.clickInfo.windowHeight = HW_SHARE_PANEL_HEIGHT;
    this.addPanel(pluginInfo)
    pluginInfo = new PluginInfo();
    pluginInfo.pluginParseInfo = new PluginParseInfo();
    pluginInfo.pluginParseInfo.bundleName = 'com.ohos.settings';
    pluginInfo.pluginParseInfo.pluginAbilityName = 'NearLinkUIExtensionSettingsAbility';
    pluginInfo.pluginParseInfo.pluginSlot = FASlotName.NEAR_LINK;
    pluginInfo.pluginParseInfo.clickInfo = new PluginClickInfo();
    pluginInfo.pluginParseInfo.clickInfo.clickType = 'window';
    pluginInfo.pluginParseInfo.clickInfo.abilityName = 'NearLinkUIExtensionSettingsAbility';
    pluginInfo.pluginParseInfo.clickInfo.windowHeight = NEAR_LINK_PANEL_HEIGHT;
    this.addPanel(pluginInfo)
    pluginInfo = new PluginInfo();
    pluginInfo.pluginParseInfo = new PluginParseInfo();
    pluginInfo.pluginParseInfo.bundleName = 'com.ohos.settings';
    pluginInfo.pluginParseInfo.pluginAbilityName = 'EbookModeExtensionSettingsAbility';
    pluginInfo.pluginParseInfo.pluginSlot = FASlotName.EBOOK;
    pluginInfo.pluginParseInfo.clickInfo = new PluginClickInfo();
    pluginInfo.pluginParseInfo.clickInfo.clickType = 'window';
    pluginInfo.pluginParseInfo.clickInfo.abilityName = 'EbookModeExtensionSettingsAbility';
    pluginInfo.pluginParseInfo.clickInfo.windowHeight = EBOOK_PANEL_HEIGHT;
    this.addPanel(pluginInfo)
    pluginInfo = new PluginInfo();
    pluginInfo.pluginParseInfo = new PluginParseInfo();
    pluginInfo.pluginParseInfo.bundleName = 'com.ohos.settings';
    pluginInfo.pluginParseInfo.pluginAbilityName = 'NotDisturbUIExtensionSettingsAbility';
    pluginInfo.pluginParseInfo.pluginSlot = FASlotName.FOCUS_MODE;
    pluginInfo.pluginParseInfo.clickInfo = new PluginClickInfo();
    pluginInfo.pluginParseInfo.clickInfo.clickType = 'window';
    pluginInfo.pluginParseInfo.clickInfo.abilityName = 'NotDisturbUIExtensionSettingsAbility';
    pluginInfo.pluginParseInfo.clickInfo.windowHeight = NOT_DISTURB_PANEL_HEIGHT;
    this.addPanel(pluginInfo)
    pluginInfo = new PluginInfo();
    pluginInfo.pluginParseInfo = new PluginParseInfo();
    pluginInfo.pluginParseInfo.bundleName = 'com.ohos.security.privacycenter';
    pluginInfo.pluginParseInfo.pluginAbilityName = 'IndicatorDetailingAbility';
    pluginInfo.pluginParseInfo.pluginSlot = WindowConstants.WINDOW_NAME_PRIVACY_INDICATOR;
    pluginInfo.pluginParseInfo.clickInfo = new PluginClickInfo();
    pluginInfo.pluginParseInfo.clickInfo.clickType = 'window';
    pluginInfo.pluginParseInfo.clickInfo.abilityName = 'IndicatorDetailingAbility';
    pluginInfo.pluginParseInfo.clickInfo.windowHeight = INDICATOR_PANEL_HEIGHT;
    this.addPanel(pluginInfo)
    pluginInfo = new PluginInfo();
    pluginInfo.pluginParseInfo = new PluginParseInfo();
    pluginInfo.pluginParseInfo.bundleName = 'com.ohos.huaweiid';
    pluginInfo.pluginParseInfo.pluginAbilityName = 'AccountUIExtensionAbility';
    pluginInfo.pluginParseInfo.pluginSlot = FASlotName.YOUTH_MODE;
    pluginInfo.pluginParseInfo.clickInfo = new PluginClickInfo();
    pluginInfo.pluginParseInfo.clickInfo.bundleName = 'com.ohos.huaweiid';
    pluginInfo.pluginParseInfo.clickInfo.clickType = 'window';
    pluginInfo.pluginParseInfo.clickInfo.abilityName = 'AccountUIExtensionAbility';
    pluginInfo.pluginParseInfo.clickInfo.windowHeight = ACCOUNT_PANEL_HEIGHT;
    pluginInfo.pluginParseInfo.clickInfo.uiExtensionType = 'ohos/account';
    pluginInfo.pluginParseInfo.clickInfo.requestType = 25;
    this.addPanel(pluginInfo)
  }

  public getPanels(): Array<PluginInfo> {
    return this.controlCenterPanels;
  }

  private addPanel(pluginInfo: PluginInfo): void {
    this.controlCenterPanels.push(pluginInfo);
  }
}