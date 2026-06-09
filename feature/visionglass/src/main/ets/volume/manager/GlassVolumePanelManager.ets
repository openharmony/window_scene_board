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

import { GlassLayoutManager } from '../../common/manager/GlassLayoutManager';
import { GlassStatusManager } from '../../common/manager/GlassStatusManager';
import GlassVolPanelConstant from '../common/GlassVolPanelConstant';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'GlassVolumePanelManager';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export class GlassVolumePanelManager {
  private static instance?: GlassVolumePanelManager;
  private timer: number = 0;

  private constructor() {
    log.showInfo(`constructor`);
  }

  /*
   * 获取音量窗口管理类实例
   *
   * @return GlassVolumePanelManager
   * */
  public static getInstance(): GlassVolumePanelManager {
    if (!GlassVolumePanelManager.instance) {
      log.showInfo(`getInstance new instance`);
      GlassVolumePanelManager.instance = new GlassVolumePanelManager();
    }
    return GlassVolumePanelManager.instance;
  }

  /*
   * 销毁音量窗口管理类实例
   *
   * */
  public static destroyInstance(): void {
    log.showInfo(`destroyInstance`);
    GlassVolumePanelManager.instance = undefined;
  }


  /*
   * 更新音量窗口位置和大小
   *
   * @param val
   * */
  public updatePosition(val: Area): void {
    if (!val) {
      return;
    }
    const height = vp2px(val.height as number);
    const top = (GlassLayoutManager.getInstance().getScreenHeightPx() - height) / GlassVolPanelConstant.TWO;
    const left = GlassLayoutManager.getInstance().getScreenWidthPx() - GlassVolPanelConstant.RIGHT_DISTANCE;
    GlassSystemSceneManager.getInstance().updateWindowRect(GlassSystemSceneType.GLASS_VOLUME, {
      top: top,
      left: left
    });
  }

  public showVolumePanel(): void {
    GlassSystemSceneManager.getInstance().showSystemView(GlassSystemSceneType.GLASS_VOLUME);
    GlassStatusManager.getInstance().activeSystemScene?.dispatch((map) => {
      map.set(GlassSystemSceneType.GLASS_VOLUME, true);
      return map;
    });
    clearTimeout(this.timer);
    this.timer = setTimeout(() => {
      GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_VOLUME);
      GlassStatusManager.getInstance().activeSystemScene?.dispatch((map) => {
        map.set(GlassSystemSceneType.GLASS_VOLUME, false);
        return map;
      });
    }, GlassVolPanelConstant.VOLUME_PANEL_SHOW_TIME);
  }
}