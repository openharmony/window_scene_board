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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { SCBSceneSessionManager, windowMgr } from '@ohos/windowscene/src/main/ets/TsIndex';
import { PluginDisplayStyle } from '../common/PluginConstants';
import { AnimManager } from '../manager/AnimManager';
import { PcStatusBarDragMgr } from '../manager/PcStatusBarDragMgr';
import { StyleManager } from '../style/PluginStyleManager';
import { StateManager } from '../manager/StateManager';
import { PluginListAdapter } from '../pluginData/PluginListAdapter';
import { WindowConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { PluginGroupingManager } from '../plugingroup/PluginGroupingManager';
import { PluginStyleUtil } from '../common/PluginStyleUtil';

const MAX_SWITCH_INTERVAL = 2000;

const TAG = 'StyleSwitchControlBase';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export abstract class StyleSwitchControlBase {

  public async requestStyleEnter(): Promise<void> {
    return new Promise(async (resolve, reject) => {
      let timerId: number | undefined = setTimeout(() => {
        log.showWarn('wait current style ' + this.getStyle().toString() + ' enter timeout');
        timerId = undefined;
        resolve();
      }, MAX_SWITCH_INTERVAL);
      this.updateCurrentStyleStatus();
      await this.waitStyleEnterFinish();
      AppStorage.setOrCreate('isModeChange', false);
      if (timerId) {
        clearTimeout(timerId);
        resolve();
      }
    });
  }

  public async requestStyleExit(): Promise<void> {
    return new Promise(async (resolve, reject) => {
      let timerId: number | undefined = setTimeout(() => {
        log.showWarn('wait current style ' + this.getStyle().toString() + ' exit timeout');
        timerId = undefined;
        resolve();
      }, MAX_SWITCH_INTERVAL);
      await this.waitStyleExitFinish();
      if (timerId) {
        clearTimeout(timerId);
        resolve();
      }
    });
  }

  protected async waitStyleExitFinish(): Promise<void> {
    this.clearCurrentStatus();
    return new Promise(async (resolve, reject) => {
      animateTo({ //消失，出现
        duration: 150,
        curve: Curve.Sharp,
        onFinish: () => {
          log.showInfo('firstAnimate finish...');
          resolve();
        }
      }, () => {
        log.showInfo(`firstAnimate begin... current style:${this.getStyle().toString()}`);
        this.notifyExit();
      });
    });
  }

  protected waitStyleEnterFinish(): Promise<void> {
    return new Promise(async (resolve) => {
      animateTo({
        duration: 150,
        curve: Curve.Sharp,
        onFinish: () => {
          log.showInfo('secondAnimate finish...');
          SCBSceneSessionManager.getInstance().executeStatusBarTypeChangeCallback();
          resolve();
        }
      }, () => {
        log.showInfo('secondAnimate begin...');
        this.notifyEnter();
      });
    });
  }

  protected abstract notifyExit(): void;

  protected abstract notifyEnter(): void;

  private clearCurrentStatus(): void {
    // reset状态
    StateManager.getInstance().resetStates();
    // reset anim
    AnimManager.getInstance().resetAnims();
    // 拖拽状态清理
    PcStatusBarDragMgr.isDragCompleted = false;
    // 二级菜单位置更新，图标位置重排会更新窗口位置
    this.hideAllPanels();
  }

  private updateCurrentStyleStatus(): void {
    windowMgr.hideWindowImmediately(WindowConstants.WINDOW_NAME_STATUS_BAR);
    StyleManager.getInstance().clear();
    PluginGroupingManager.getInstance().resortPlugins();
    AppStorage.setOrCreate('isModeChange', true);
    AppStorage.setOrCreate('statusBarType', PluginStyleUtil.getStatusBarTypeValue(this.getStyle()));
    StyleManager.getInstance().getDockStatusBarStyle().opacity = 0;
    StyleManager.getInstance().getStatusBarStyle().opacity = 0;
  }

  /**
   * 菜单隐藏
   *
   * @param statusBarType 状态栏类型
   */
  private hideAllPanels(): void {
    PluginListAdapter.getInstance().getAllData().forEach((pluginInfo) => {
      windowMgr.hideWindowImmediately(pluginInfo.getSlot());
    })
  }

  protected abstract getStyle(): PluginDisplayStyle;
}