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

import { LogHelper, LogDomain, FileUtils, CheckEmptyUtils } from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { HiSysReportEvent, ReportDomain, DeviceHelper, GlobalContext, EvtBus } from '@ohos/frameworkwrapper';
import display from '@ohos.display';
import camera from '@ohos.multimedia.camera';
import { FlashlightTipsConstants } from '../constants/FlashlightTipsConstants';
import { vibrator } from '@kit.SensorServiceKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Context } from '@kit.AbilityKit';
import { FlashlightLiveEvent } from '@ohos/systemuicommon';

const TAG = 'FlashlightTipsUtil';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class FlashlightTipsUtil {
  // 外屏打点工具类
  private static mOuterHomeReportEvent: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain
    .OUTER_HOME_UE);

  // 手电筒管理器
  private static mCameraManager: camera.CameraManager | null = null;

  /**
   * 是否能够打开手电筒提示语页面
   *
   * @param flashlightStatus 外部状态,是否支持打开手电筒
   * @returns 是否能够打开手电筒提示语页面
   */
  public static isOpenFlashlightTips(flashlightStatus: boolean): boolean {
    if (!flashlightStatus) {
      log.showInfo(`flashlightStatus is false`);
      return false;
    }
    // 如果是扩展新形态小折叠产品手机并且处于外屏,则需要打开手电筒提示语页面
    return false;
  }

  /**
   * 返回手电筒提示语资源是否存在
   *
   * @returns 资源是否存在
   */
  public static existFlashlightTipsResource(): boolean {
    return FileUtils.isExist(FlashlightTipsConstants.RESOURCE_PATH);
  }

  /**
   * 关闭手电筒
   *
   * @param isFold 是否是折叠关闭手电筒, 如果是折叠关闭则需要打点
   */
  public static closeFlashlight(isFold?: boolean): void {
    if (CheckEmptyUtils.isEmpty(FlashlightTipsUtil.getCameraManager())) {
      log.showError(`closeFlashlight err mCameraManager is null`);
      return;
    }
    if (FlashlightTipsUtil.getCameraManager()?.getTorchMode() === FlashlightTipsConstants.CLOSE_FLASHLIGHT_VALUE) {
      log.showInfo('flashlight is close');
      return;
    }
    if (isFold) {
      // 折叠关闭手电筒打点
      FlashlightTipsUtil.flashlightTipsReport(FlashlightTipsConstants.PNAMEID,
        FlashlightTipsConstants.PVERSIONID, FlashlightTipsConstants.CLOSE_FLASHLIGHT_BY_FOLD_EVENT);
    }
    FlashlightTipsUtil.setFlashlightTorchMode(FlashlightTipsConstants.CLOSE_FLASHLIGHT_VALUE);
  }

  /**
   * 打开手电筒
   *
   * @param isNeedVibrate 是否需要震动
   */
  public static openFlashlight(isNeedVibrate: boolean): void {
    if (CheckEmptyUtils.isEmpty(FlashlightTipsUtil.getCameraManager())) {
      log.showError(`openFlashlight err mCameraManager is null`);
      return;
    }
    if (isNeedVibrate) {
      FlashlightTipsUtil.startVibrate();
    }
    FlashlightTipsUtil.setFlashlightTorchMode(FlashlightTipsConstants.OPEN_FLASHLIGHT_VALUE);
    FlashlightTipsUtil.postFlashlightLiveEvent();
  }

  private static postFlashlightLiveEvent(): void {
    let event = new FlashlightLiveEvent();
    event.isOn = true;
    EvtBus.post(FlashlightLiveEvent, event);
  }

  private static setFlashlightTorchMode(status: number): void {
    try {
      FlashlightTipsUtil.getCameraManager()?.setTorchMode(status);
    } catch (err) {
      log.error(`set torch mode: ${status} failed: ${err?.message}`);
    }
  }

  /**
   * 外屏手电筒打点信息
   * @param pNameId pNameId
   * @param pVersionId pNameId
   * @param flashlightStatus flashlightStatus
   */
  public static flashlightTipsReport(pNameId: string, pVersionId: string, flashlightStatus: number): void {
    if (CheckEmptyUtils.isEmpty(pNameId) || CheckEmptyUtils.isEmpty(pVersionId)) {
      log.showError(`flashlightTipsReport error pNameId:
        ${pNameId} pVersionId: ${pVersionId} flashlightStatus: ${flashlightStatus}`);
      return;
    }
    let params: FlashlightTipsReportParams = {
      PNAMEID: pNameId,
      PVERSIONID: pVersionId,
      FLASHLIGHT_STATUS: flashlightStatus
    };
    FlashlightTipsUtil.mOuterHomeReportEvent
      .reportBehavior(FlashlightTipsConstants.LAUNCHER_FLASHLIGHT_TIPS_EVENT, params);
  }

  /**
   * 振动
   */
  public static startVibrate(): void {
    try {
      vibrator.startVibration({
        type: 'time',
        duration: 100,
      }, {
        usage: 'physicalFeedback'
      }, (error: BusinessError) => {
        if (error) {
          log.showError(`startVibrate Failed to start vibration. Code: ${error.code}, message: ${error.message}`);
          return;
        }
        log.showInfo('startVibrate Succeed in starting vibration');
      });
    } catch (err) {
      let e: BusinessError = err as BusinessError;
      log.showError(`startVibrate An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
    }
  }

  /**
   * 显示手电筒提示页
   */
  public static showFlashlightTipsPage(): void {
    GlobalContext.getContext()?.eventHub.emit(FlashlightTipsConstants.EXTERNAL_SCREEN_FLASHLIGHT_EVENT, true);
  }

  /**
   * 关闭手电筒提示页
   */
  public static closeFlashlightTipsPage(): void {
    GlobalContext.getContext()?.eventHub.emit(FlashlightTipsConstants.EXTERNAL_SCREEN_FLASHLIGHT_EVENT, false);
  }

  /**
   * 关闭控制中心
   */
  public static closeDropdownPanel(): void {
    GlobalContext.getContext()?.eventHub.emit(FlashlightTipsConstants.CLOSE_DROPDOWN_PANEL_EVENT, true);
  }

  private static getCameraManager(): camera.CameraManager | null {
    if (FlashlightTipsUtil.mCameraManager == null) {
      let context: Context = GlobalContext.getContext();
      if (context != null) {
        FlashlightTipsUtil.mCameraManager = camera.getCameraManager(context);
      }
    }
    return FlashlightTipsUtil.mCameraManager;
  }
}

class FlashlightTipsReportParams {
  // 进程包名
  public PNAMEID?: string;

  // 进程名
  public PVERSIONID?: string;

  // 手电筒状态打点
  public FLASHLIGHT_STATUS?: number;
}