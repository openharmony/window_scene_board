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

export class ReportParams {
  public static PACKAGE_NAME: string = 'com.ohos.sceneboard';
  public static PROCESS_NAME: string = 'sceneBoard';
}
// 通知中心和控制中心
export interface NTFControlParams {
  PNAMEID?: string;
  PVERSIONID?: string;
}

export interface CCBrightnessClick extends NTFControlParams {
  STARTVALUE: number;
  CLICKEDVALUE: number;
  ISNIGHTMODE: string;
  TIMESTAMP: string;
  LOCKSTATUS?: number;
  SCREENTYPE?: number;
}

export interface CCEditIconClick extends NTFControlParams {
  TIMESTAMP: string;
  SWITCHNUMBER: number;
  SWITCHLIST: string;
  LOCKSTATUS?: number;
}

export interface CCEditExpandLibrary extends NTFControlParams {
  TIMESTAMP: string;
  SWITCHNUMBER: number;
  SWITCHLIST: string;
}

export interface CCEditCollapseLibrary extends NTFControlParams {
  TIMESTAMP: string;
  TYPE: number;
}

export interface CCEditAddQuickSwitch extends NTFControlParams {
  TIMESTAMP: string;
  SWITCHNUMBER: number;
  SWITCHNAME: string;
}

export interface CCEditRemoveQuickSwitch extends NTFControlParams {
  TIMESTAMP: string;
  SWITCHNUMBER: number;
  SWITCHNAME: string;
  SWITCHLOCATION: number;
}

export interface CCEditClickSuccess extends NTFControlParams {
  TIMESTAMP: string;
  SWITCHNUMBER: number;
  SWITCHLIST: string;
}

export interface CCEditDialogClickSave extends NTFControlParams {
  TIMESTAMP: string;
  SWITCHNUMBER: number;
  SWITCHLIST: string;
}

export interface CCEditDialogClickCancel extends NTFControlParams {
  TIMESTAMP: string;
}

export interface CCEditMoveSwitch extends NTFControlParams {
  TIMESTAMP: string;
  NAME: string;
  OLDLOCATION: number;
  NEWLOCATION: number;
}

export interface CCNCAutoHide extends NTFControlParams {
  BUNDLENAME: string;
  ABILITYNAME: string;
}

export interface CCClickPrivacySensor extends NTFControlParams {
  TIMESTAMP: string;
}

export interface CCClickMultimediaSensor extends NTFControlParams {
  TIMESTAMP: string;
  AVAILABLELIST: string;
}

export interface CCPrivacySensorShow extends NTFControlParams {
  TIMESTAMP: string;
  PRIVACYSENSOR: number;
  ACCESSINGPRIVACY: string;
  PERMISSIONPRIVACY: string;
}

export interface CCDataClone extends NTFControlParams {
  OLDSWITCHNUMBER: number;
  OLDSWITCHLIST: string;
  NEWSWITCHNUMBER: number;
  NEWSWITCHLIST:string;
  TYPE: number;
}

export interface QuickToggleTristateParams extends NTFControlParams {
  CURRENT_STATE?: number;
  TOGGLE_NAME?: string;
  NEXT_STATE?: number;
  TIMESTAMP?: string;
  SCREENTYPE?: number;
}

export interface CCNumberSwitchToast extends NTFControlParams {
  UPPERLOWERTHRESHOLDSSWITCHVALUE?: string;
  TOASTNUMBERSWITCHVALUE?: string;
  TIMESTAMP?: string;
}
