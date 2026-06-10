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
import {
  LogDomain,
  LogHelper,
  SingletonHelper,
  CommonUtils,
  AppStorageUtil,
} from '@ohos/basicutils';

import {
  EvtBus,
  PluginRequestEvent,
  PluginSlot,
  GlobalContext,
  AccountMgr,
  sSettingsUtil
} from '@ohos/frameworkwrapper';
import { BaseController } from '@ohos/controlcentercommon/Index';
import { FocusModeData } from '../common/Constants';
import type { EventManager } from '@ohos/frameworkwrapper';
import dataShare from '@ohos.data.dataShare';
import type { BusinessError } from '@ohos.base';
import { FocusModeSwitchDataEvent, SettingUtil, DataShareUtils} from '@ohos/systemuicommon';
import { dataSharePredicates, DataShareResultSet } from '@kit.ArkData';
import Settings from '@ohos.settings';

const TAG = 'Model.FocusModeController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const FOCUS_MODE_DEFAULT: string = '1';
const ICON_ID_DEFAULT: string = 'moon_fill';
const MODE_NAME_DEFAULT: string = '';
const SYSTEM_MODE_NUM: number = 50;
const INTELLIGENTSCENE_BUNDLE_NAME: string = 'com.ohos.intelligentscene';
const MODE_NAME_EXCLUDE_LENGTH: number = 8;

export class FocusModeController extends BaseController<FocusModeData> {
  private mFocusModeData: FocusModeData = new FocusModeData();

  private focusModeEventMgr: EventManager = EvtBus.createEventManager();

  private focusMode: string = FOCUS_MODE_DEFAULT;

  private iconIdDataShareHelper: dataShare.DataShareHelper | undefined = undefined;

  private profileDataShareHelper: dataShare.DataShareHelper | undefined = undefined;

  private focusDisableValue = '0';

  constructor() {
    super();
    this.onStart();
  }

  onStart(): void {
    log.showInfo('focus mode onStart');
    super.onStart();
    this.initProfileDataShareHelper();
  }

  private initProfileDataShareHelper(): void {
    try {
      let context = GlobalContext.getContext();
      dataShare.createDataShareHelper(context, this.mFocusModeData.profileUri,
        (err:BusinessError, data:dataShare.DataShareHelper) => {
          if (err !== undefined) {
            log.showError(`initProfileDataShareHelper error code:${err.code}, message:${err.message}`);
            return;
          }
          log.showInfo('focus_mode_profile initProfileDataShareHelper success');
          this.profileDataShareHelper = data;
          this.onFocusModeProfileChange();
          this.profileDataShareHelper?.on('dataChange', this.mFocusModeData.profileUri, () => {
            log.showInfo('onFocusModeProfileChange');
            this.onFocusModeProfileChange();
          });
        });
    } catch (err) {
      log.showError(`focus_mode_profile createDataShareHelper error code:${err?.code}, message:${err?.message}`);
    }
  }

  private async onFocusModeProfileChange(): Promise<void> {
    if (!this.profileDataShareHelper) {
      log.showInfo('profileDataShareHelper is null');
      this.initProfileDataShareHelper();
      return;
    }
    try {
      this.focusMode = DataShareUtils.getSettingsSecureValueSync('focus_mode_profile', this.focusDisableValue);
      let iconId = DataShareUtils.getSettingsSecureValueSync('intelligent_scene_icon', ICON_ID_DEFAULT);
      let modeName = DataShareUtils.getSettingsSecureValueSync('intelligent_scene_name', MODE_NAME_DEFAULT);
      log.showInfo(`focusMode: ${this.focusMode} iconId: ${iconId}`);
      AppStorageUtil.setOrCreate('focusModeIconId', iconId);
      AppStorageUtil.setOrCreate('focusModeName', modeName);
      this.handleStatusBarState(this.focusMode !== this.focusDisableValue);
    } catch (err) {
      log.showInfo(`error: code: ${err.code}, message: ${err.message} `);
    };
  }

  onStop(): void {
    log.showInfo('focus mode onStop');
    super.onStop();
    this.focusModeEventMgr.offAll();
    this.profileDataShareHelper?.off('dataChange', this.mFocusModeData.profileUri);
  }

  isAvailable(): boolean {
    return true;
  }

  getData(): FocusModeData {
    return this.mFocusModeData;
  }

  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_DO_NOT_DISTURB;
  }

  getAccessibilityText(modeName: string): string {
    if (Number(this.focusMode) > SYSTEM_MODE_NUM) {
      return modeName;
    }
    let accessibilityText = '';
    try {
      let context = GlobalContext.getContext();
      let res = context.createBundleContext(INTELLIGENTSCENE_BUNDLE_NAME).resourceManager;
      accessibilityText = res.getStringByNameSync(modeName.substr(MODE_NAME_EXCLUDE_LENGTH));
    } catch (err) {
      log.showInfo(`getAccessibilityText error: code: ${err.code}, message: ${err.message} `);
    }
    return accessibilityText;
  }

  private handleStatusBarState(newState: boolean): void {
    let oldState = this.sbPluginRequest.isVisible();
    log.showInfo(`focus mode status bar status change, newState: ${newState}, oldState: ${oldState}`);
    if (oldState !== newState) {
      this.mFocusModeData.isFocusModeEnable = newState;
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }
}

let sFocusModeController = SingletonHelper.getInstance(FocusModeController, TAG);

export default sFocusModeController as FocusModeController;