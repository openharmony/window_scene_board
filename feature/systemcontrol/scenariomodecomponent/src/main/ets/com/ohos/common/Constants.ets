/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

export default class Constants {
  public static readonly FOCUS_MODE_PROFILE_URI: string =
    'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_100?Proxy=true&key=focus_mode_profile';
  public static readonly LAST_INTELLIGENT_SCENE_URI: string =
    'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_100?Proxy=true&key=last_intelligent_scene_id';
  public static readonly OPERATE_SCENE_CHANGE: string =
    'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_100?Proxy=true&key=operate_scene_change';
}

export class ScenarioModeData {
  public iconId: string = 'moon_fill';
  public isDefaultMode: boolean = true;
}

export interface CallMessage {
  method: string;
  extra?: ModeManualEnableParam;
}

export interface ModeManualEnableParam {
  modeId: string,
  openType?: string,
}
