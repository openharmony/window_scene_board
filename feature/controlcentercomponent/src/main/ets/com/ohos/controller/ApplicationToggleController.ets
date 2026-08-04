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
import {
  HiDfxEventUtil,
  PluginSlot,
  sEventManager,
  obtainStartServiceExt,
  obtainStartAbilityWithWant,
  GlobalContext,
  obtainLocalEvent
} from '@ohos/frameworkwrapper';
import { EdmAdminManager } from '@ohos/systemuicommon/src/main/ets/manager/EdmAdminManager';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import { FASlotName } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { VoiceTranslateUtils } from '../common/VoiceTranslateUtils';
import { AbilityConstant, StartOptions } from '@kit.AbilityKit';
import { screenLock } from '@kit.BasicServicesKit';

const TAG: string = 'Ctrl.CommonToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const PERSIST_EDM_CONTROL_SCREENSHOT_CONFIG: string = 'persist.edm.disallow_screenshot';
const LOCAL_EVENT_TYPE: string = 'local';

// 只具备跳转应用能力的开关的viewModel
export class ApplicationToggleController extends ToggleBaseViewModel {
  public startServiceFunc: (() => void) | undefined = () => {
    this.startService();
  }

  constructor(toggleId: string) {
    super();
    this.toggleId = toggleId;
  }

  onStart(): void {
    this.getViewData().icon = this.getIcon();
    this.getViewData().isSymbolIcon = this.useSymbolIcon();
    this.getViewData().label = this.getLabel();
    this.updateDisableState();
  }

  /**
   * 获取开关名称
   */
  getLabel(): Resource | string {
    if (this.toggleId === PluginSlot.SLOT_CONTROL_SCREENSHOT) {
      log.showInfo(`get screenshot label`);
      return $r('app.string.screen_shot_widget_name');
    } else if (this.toggleId === PluginSlot.SLOT_CONTROL_SCREEN_RECORDER) {
      log.showInfo(`get screen recorder label`);
      return $r('app.string.screen_recorder_widget_name');
    } else if (this.toggleId === PluginSlot.SLOT_CONTROL_SCANNER) {
      return $r('app.string.scanner_widget_name');
    } else if (this.toggleId === PluginSlot.SLOT_CONTROL_MULTI_WINDOW) {
      log.showInfo('get multi window label');
      return $r('app.string.multi_window_widget_name');
    } else if (this.toggleId === FASlotName.QUICK_NOTE) {
      log.showInfo(`get quicknote label`);
      return $r('app.string.notepad_quick_note_title');
    } else {
      return $r('app.string.screen_shot_widget_name');
    }
  }

  /**
   * 获取开关图标
   */
  getIcon(): Resource {
    if (this.toggleId === PluginSlot.SLOT_CONTROL_SCREENSHOT) {
      return $r('sys.symbol.rectangle_and_cut');
    } else if (this.toggleId === PluginSlot.SLOT_CONTROL_SCREEN_RECORDER) {
      return $r('app.media.ic_widget_screen_recorder');
    } else if (this.toggleId === PluginSlot.SLOT_CONTROL_SCANNER) {
      return $r('app.media.ic_public_scan_filled');
    } else if (this.toggleId === PluginSlot.SLOT_CONTROL_MULTI_WINDOW) {
      return $r('sys.symbol.rectangle_on_rectangle_fill');
    } else if (this.toggleId === FASlotName.QUICK_NOTE) {
      return $r('sys.symbol.doc_plaintext_and_pencil');
    } else {
      return $r('sys.symbol.rectangle_and_cut');
    }
  }

  private useSymbolIcon(): boolean {
    return this.toggleId === PluginSlot.SLOT_CONTROL_SCREENSHOT ||
      this.toggleId === PluginSlot.SLOT_CONTROL_MULTI_WINDOW ||
      this.toggleId === FASlotName.QUICK_NOTE;
  }

  isAvailable(): boolean {
    return true;
  }

  /**
   * 更新快捷开关的置灰状态
   */
  public updateDisableState(): void {
    switch (this.toggleId) {
      case PluginSlot.SLOT_CONTROL_SCREENSHOT:
        if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_CONTROL_SCREENSHOT_CONFIG)) {
          this.getViewData().isUnavailable = true;
          return;
        }
        this.getViewData().isUnavailable = false;
        break;
      default:
        return;
    }
  }

  handleOneClick(): void {
    this.startService();
  }

  public startService(): void {
    switch (this.toggleId) {
      case PluginSlot.SLOT_CONTROL_SCREENSHOT:
        if (this.getViewData().isUnavailable) {
          log.showWarn('screenshot disabled');
          if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_CONTROL_SCREENSHOT_CONFIG)) {
            EdmAdminManager.instance.showToastWhenInoperable();
          }
          return;
        }
        DropDownPanelManager.animToDismissEvent();
        log.showInfo('start screenshot Ability');
        DropDownPanelManager.setPanelDismissCallback(()=>{
          HiDfxEventUtil.reportControlCenterScreenshotClick(HiDfxEventUtil.SHOT_FULL_SCREEN);
          log.showInfo('Start Screenshot Event');
          EventManagerAdapter.startAbility(obtainStartServiceExt('com.ohos.screenshot',
            'com.ohos.screenshot.ServiceExtAbility'));
        })
        break;
      case PluginSlot.SLOT_CONTROL_SCANNER:
        log.showInfo('start scanner Ability');
        this.handleOnControlCenterWithScreenLock(():void => this.goToScanner(), false);
        break;
      case FASlotName.QUICK_NOTE:
        log.showInfo('start quick note Ability');
        this.goToQuickNote();
        break;
      default:
        log.showInfo('other slot: ' + this.toggleId);
    }
  }

  private goToScanner() {
    log.showInfo('start scanner Ability - disabled, vassistant removed');
  }

  private goToQuickNote() {
    log.showInfo('handleClick goToQuickNote');
    // let wantInfo: Want = {
    //   bundleName: 'com.ohos.notepad',
    //   abilityName: 'QuickNoteAbility',
    //   parameters: {
    //     'fastNoteLaunchSource': 3
    //   }
    // };
    // 拉起备忘录(速记)
    let wantInfo: Want = {
      bundleName: 'com.ohos.note',
      abilityName: 'MainAbility',
      parameters: {
        'fastNoteLaunchSource': 3
      }
    };
    const option: StartOptions = {
      windowMode: screenLock.isLocked() ? AbilityConstant.WindowMode.WINDOW_MODE_FULLSCREEN :
      AbilityConstant.WindowMode.WINDOW_MODE_FLOATING
    };
    try {
      log.showInfo(`Begin to quick note ability`);
      this.handleClickWithScreenLockAndEdit(() => GlobalContext.getContext().startAbility(wantInfo, option));
    } catch (error) {
      log.showError(`Start goToQuickNote failed with ${error}`);
    }
    EventManagerAdapter.startAbility(obtainLocalEvent('hideControlPanel', ''));
    DropDownPanelManager.animToDismissEvent();
    log.showInfo('handleClick goToQuickNote end');
    return true;
  }
}
