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

import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import {
  CommonUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  EvtBus,
  DeviceHelper,
  sEventManager,
  WallpaperChangeEvent,
  obtainLocalEvent,
  PluginSlot,
  WallpaperColorManager,
  PluginAbilityType,
  PluginClickInfo,
  PluginClickType,
  PluginComponentInfo
} from '@ohos/frameworkwrapper';
import { StartAbilityUtilAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/StartAbilityUtilAdapter';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import Want from '@ohos.app.ability.Want';
import pluginComponentManager from '@ohos.pluginComponent';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';

const TAG = 'Ctrl.PluginToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class PluginToggleController extends ToggleBaseViewModel {

  /**
   * plugin唯一标识
   * 用于PluginPushListener
   */
  public slot: string;

  /**
   * plugin组件数据
   */
  private pluginInfo: PluginComponentInfo;

  /**
   * plugin组件是否连接
   */
  public isConnect: boolean;

  private isPc: boolean;

  private avgColor: string = '#00FFFFFF';

  constructor(slot: string, pluginInfo: PluginComponentInfo) {
    super();
    this.slot = slot;
    this.pluginInfo = pluginInfo;
    this.isConnect = true;
    this.isPc = DeviceHelper.isPC();

    WallpaperColorManager.getInstance().loadWallpaper();
    EvtBus.on(WallpaperChangeEvent, (data: WallpaperChangeEvent) => {
        this.avgColor = data.avgColor;
    })
  }

  isAvailable(): boolean {
    return this.isConnect;
  }

  handleOneClick(): void {
    // 判断是否有点击信息
    let clickInfo = this.pluginInfo.pluginParseInfo?.clickInfo;
    if (this.needUnlock()) {
      this.handleClickWithScreenLock((): void => this.updatePluginData('CLICKED'));
      return;
    }
    if (CommonUtils.isInvalid(clickInfo)) {
      log.showInfo(`${this.slot}, handleClick has not click info`);
      return;
    }
    log.showInfo(`${this.slot}, handleClick.`);
    this.startAbility(clickInfo);
  }

  handleLongClick(): boolean {
    if (this.pluginInfo?.hasSubPage()) {
      if (this.needUnlock()) {
        this.handleOnControlCenterWithScreenLock((): void => {
          sToggleSubWindowController.showSubWindow(this.slot);
        });
      } else {
        sToggleSubWindowController.showSubWindow(this.slot);
      }
      return true;
    }
    // 判断是否有点击信息
    let clickInfo = this.pluginInfo.pluginParseInfo?.longClickInfo;
    if (CommonUtils.isInvalid(clickInfo)) {
      log.showInfo(`${this.slot}, handleLongClick has not click info`);
      this.handleOneClick();
      return true;
    }
    log.showInfo(`${this.slot}, handleLongClick.`);
    return this.startAbility(clickInfo);
  }

  handleLabelClick(slot: string): boolean {
    log.showInfo('handleLabelClick:' + slot);
    if (!DeviceHelper.isPC()) {
      sToggleSubWindowController.showSubWindow(slot);
    } else if (slot == PluginSlot.SLOT_CONTROL_SHARE) {
      let bundleName: string = 'com.ohos.instantshare';
      let abilityName: string = 'ShareSettingsDialogService';
      let want: Want = {
        bundleName: bundleName,
        abilityName: abilityName,
        parameters:{
          wallpaperAvgColor:this.avgColor
        }
      }
      sEventManager.publish(obtainLocalEvent('hideControlPanel', ''));
      StartAbilityUtilAdapter.startServiceExtensionAbility(want);
    }
    return true;
  }

  private startAbility(clickInfo: PluginClickInfo): boolean {
    // 直接拉起ability，收起面板
    if (clickInfo.clickType == PluginClickType.TYPE_ABILITY) {
      let want: Want = { bundleName: clickInfo.bundleName, abilityName: clickInfo.abilityName };
      // 区分启动ability和serviceExtensionAbility
      if (PluginAbilityType.isTypeExtension(clickInfo.abilityType)) {
        StartAbilityUtilAdapter.startServiceExtensionAbility(want);
      } else {
        StartAbilityUtilAdapter.startAbility(want);
      }
      DropDownPanelManager.postRequestHideWindow(true);
      return true;
    }
    return false;
  }

  handleHover(isHover: boolean): void {
    this.updatePluginData(isHover ? 'HOVER_IN' : 'HOVER_OUT');
  }

  public updatePluginData(action: string): void {
    log.showInfo('updatePluginData action: ' + action + ', slot:' + this.slot);
    pluginComponentManager.request(
      {
        owner: {
          bundleName: 'com.ohos.systemui',
          abilityName: 'ServiceExtAbility'
        },
        target: {
          bundleName: this.pluginInfo.pluginParseInfo.bundleName,
          abilityName: this.pluginInfo.pluginParseInfo.pluginAbilityName
        },
        name: this.pluginInfo.pluginParseInfo.pluginTemplateName,
        data: {
          'action': action
        }
      },
      (err, data) => {
        log.info(`err: ${err?.message} `);
      }
    )
  }

  private needUnlock(): boolean {
    switch (this.slot) {
      case PluginSlot.SLOT_CONTROL_SHARE:
      case PluginSlot.SLOT_CONTROL_CAST:
      case PluginSlot.SLOT_CONTROL_DEVICE_COLLABORATION:
        return true;
      default:
        return false;
    }
  }
}