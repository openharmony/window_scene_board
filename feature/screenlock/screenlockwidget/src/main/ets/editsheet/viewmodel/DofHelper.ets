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
import { image } from '@kit.ImageKit';
import { display } from '@kit.ArkUI';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import {
  DofWallpaperStaticStateType,
  EditStaticStateType,
  SlMainStateType,
  SlSubStateType,
  WidgetStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { IDofParam, slWallpaperMgr } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperManager';
import { FileUtil } from '@ohos/screenlockcommon/src/main/ets/utils/FileUtil';
import { ClockBindStateType, DisplayUtils, ISlState } from '@ohos/screenlockcommon';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { SCBScreenSessionManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { WidgetAnimState } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/bean/WidgetAnimState';
import { slStateHelper } from '../../common/utils/SlStateHelper';
import { UDFontAdapterUtil } from '../../clock/common/UDFontAdapterUtil';
import { ClockLayout } from '../../common/WidgetParam';
import { ClockAdapterFactory } from '../../clock/adapter/ClockAdapter';
import { UseScene } from '../../common/adapter/Constans';

const TAG = 'DofHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const ROTATE_VERTICAL = 90; // 屏幕角度90度
const ROTATE_REVERSES = 270; // 屏幕角度270度
const DISPLAY_ROTATION = 'DOF_DISPLAY_ROTATION';

//防止编译失败自己定义的接口
interface PixelMapInfo {
  x: number;
  y: number;
}

interface DeviceInfo {
  x: number;
  y: number;
}

interface DofInputWithComponents {
  pixelMapInfo: PixelMapInfo;
  deviceInfo: DeviceInfo;
  isDelay: boolean;
  timeDesignType: number;
  clockType: number;
  needRender: boolean;
  forceFreeze: boolean;
  controlMode: number;
}

export class DofHelper {
  private dofScenesInfo: Map<string, IDofParam> | undefined = undefined;

  // 景深壁纸动效状态管理
  private dofAnimCtrl: WidgetAnimState | undefined = slUiStateMgr.getSlState(
    SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE) ?.getSlState(
      WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;

  /**
   * 景深静态状态监听器
   */
  private dofStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === DofWallpaperStaticStateType.DOF_TYPE_CALC) {
        this.calDofByDisplay();
      }
    }
  };

  /**
   * 锁屏编辑静态状态监听器
   */
  private editorStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_EDIT_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === EditStaticStateType.IS_CANCEL_EDIT) {
        let isCancel = slUiStateMgr.getSlState(SlMainStateType.SL_EDIT_STATIC_STATE)?.getSlState(
          EditStaticStateType.IS_CANCEL_EDIT) as boolean;
        if (!isCancel) {
          return;
        }
        // 取消应用 从配置文件中读取配置信息 恢复修改
        this.dofScenesInfo = slUiStateMgr.getSlState(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE)?.getSlState(
          DofWallpaperStaticStateType.DOF_TYPE_CONFIG) as Map<string, IDofParam>;
        this.dofScenesInfo?.forEach((value, key) => {
          let dofInfo = FileUtil.getDofInfoByFile(value.configPath);
          if (!dofInfo) {
            return;
          }
          value.isDofDone = dofInfo.isDofDone;
          value.isDof = dofInfo.isDof;
          value.configContent = dofInfo.configContent;
        })
        log.showInfo('cancel editor dof, reset dof scenes info.')
        this.updateDofScenesInfo();
      }
    }
  };

  public init(): void {
    slUiStateMgr.registerSlStateChangeListener(this.dofStaticStateListener);
    slUiStateMgr.registerSlStateChangeListener(this.editorStaticStateListener);
    log.showWarn(`getScreenRotation=${SCBScreenSessionManager.getInstance().getScreenRotation()}`)
    let rotation = SCBScreenSessionManager.getInstance().getScreenRotation();
    slWallpaperMgr.setPortrait(rotation !== ROTATE_VERTICAL && rotation !== ROTATE_REVERSES);
  }

  public release(): void {
    slUiStateMgr.unregisterSlStateChangeListener(this.dofStaticStateListener);
    slUiStateMgr.unregisterSlStateChangeListener(this.editorStaticStateListener);
  }

  // private async calDof(dofImage: image.PixelMap | undefined): Promise<CalDofResultProxy> {
  //   const dofWallStateResult: CalDofResultProxy = {
  //     isDof: false,
  //     clockType: 0
  //   };
  //   if (dofImage === undefined) {
  //     log.showError(`getImageInfoSync failed, dofImage is undefined`);
  //     return dofWallStateResult;
  //   }
  //   let imageInfo: image.ImageInfo | undefined = undefined;
  //   try {
  //     imageInfo = dofImage.getImageInfoSync();
  //   } catch (e) {
  //     log.showError(`getImageInfoSync failed, err code=${e.code}`);
  //     return dofWallStateResult;
  //   }
  //   let screenDisplay: display.Display | undefined = DisplayUtils.getDefaultDisplaySync();
  //   if (screenDisplay === undefined) {
  //     return dofWallStateResult;
  //   }
  //
  //   let controlMode = slUiStateMgr.getSlState(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE)?.getSlState(
  //     DofWallpaperStaticStateType.DOF_CALC_CONTROL_MODE) as number;
  //   let dofInput: DofInputWithComponents = {
  //     pixelMapInfo: {
  //       x: imageInfo?.size.width ?? 0,
  //       y: imageInfo?.size.height ?? 0,
  //     },
  //
  //     deviceInfo: {
  //       x: screenDisplay.width,
  //       y: screenDisplay.height,
  //     },
  //     isDelay: true,
  //     timeDesignType:  0,
  //     clockType: 0,
  //     needRender: false,
  //     forceFreeze: this.isFreezeReverseForDof(),
  //     controlMode: controlMode
  //   };
  //   // 传入计算的图片是原图100%的，实际锁屏编辑存在1.1倍放大，需要设置景深计算的范围和锁屏编辑的范围一致
  //   let dofRect = this.getDofImageRect(imageInfo);
  //   let dofState: CalDofResultProxy = await DofWithClockComponent.calDofWithDofImage(dofImage, dofInput, dofRect);
  //   log.showWarn(`calDof calDofWithDofImage isDof:${dofState.isDof} outType:${dofState.clockType}`);
  //   return dofState;
  // }

  private async calDof(dofImage: image.PixelMap | undefined): Promise<ESObject> {
    const dofWallStateResult: ESObject = {
      isDof: false,
      clockType: 0
    };
    if (dofImage === undefined) {
      log.showError(`getImageInfoSync failed, dofImage is undefined`);
      return dofWallStateResult;
    }
    let imageInfo: image.ImageInfo | undefined = undefined;
    try {
      imageInfo = dofImage.getImageInfoSync();
    } catch (e) {
      log.showError(`getImageInfoSync failed, err code=${e.code}`);
      return dofWallStateResult;
    }
    let screenDisplay: display.Display | undefined = DisplayUtils.getDefaultDisplaySync();
    if (screenDisplay === undefined) {
      return dofWallStateResult;
    }

    let controlMode = slUiStateMgr.getSlState(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE)?.getSlState(
      DofWallpaperStaticStateType.DOF_CALC_CONTROL_MODE) as number;
    let dofInput: DofInputWithComponents = {
      pixelMapInfo: {
        x: imageInfo?.size.width ?? 0,
        y: imageInfo?.size.height ?? 0,
      },

      deviceInfo: {
        x: screenDisplay.width,
        y: screenDisplay.height,
      },
      isDelay: true,
      timeDesignType:  0,
      clockType: 0,
      needRender: false,
      forceFreeze: this.isFreezeReverseForDof(),
      controlMode: controlMode
    };
    // 传入计算的图片是原图100%的，实际锁屏编辑存在1.1倍放大，需要设置景深计算的范围和锁屏编辑的范围一致
    // let dofRect = this.getDofImageRect(imageInfo);
    // let dofState: CalDofResultProxy = await DofWithClockComponent.calDofWithDofImage(dofImage, dofInput, dofRect);
    // log.showWarn(`calDof calDofWithDofImage isDof:${dofState.isDof} outType:${dofState.clockType}`);
    return {};
  }

  private isFreezeReverseForDof(): boolean {
    let state: ISlState | undefined = slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_BIND_STATE);
    let hasCard: boolean = state?.getSlState(ClockBindStateType.HAS_FORM_CARD) as boolean;
    return UDFontAdapterUtil.isUDFont() || hasCard;
  }

  // private getDofImageRect(imageInfo: image.ImageInfo): RectProxy {
  //   return {
  //     x: imageInfo.size.width * 0.05 / 1.1,
  //     y: imageInfo.size.height * 0.05 / 1.1,
  //     width: imageInfo.size.width / 1.1,
  //     height: imageInfo.size.height / 1.1
  //   };
  // }

  private getDofImageRect(imageInfo: image.ImageInfo): ESObject {
    return {
      x: imageInfo.size.width * 0.05 / 1.1,
      y: imageInfo.size.height * 0.05 / 1.1,
      width: imageInfo.size.width / 1.1,
      height: imageInfo.size.height / 1.1
    };
  }

  private calDofByDisplay(): void {
    this.dofScenesInfo = slUiStateMgr.getSlState(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE)?.getSlState(
      DofWallpaperStaticStateType.DOF_TYPE_CONFIG) as Map<string, IDofParam>;
    let calcType = slUiStateMgr.getSlState(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE)?.getSlState(
      DofWallpaperStaticStateType.DOF_TYPE_CALC) as string;

    let needWriteConfigFile = slUiStateMgr.getSlState(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE)?.getSlState(
      DofWallpaperStaticStateType.NEED_WRITE_CONFIG_FILE) as boolean;

    let dofCalcInfo = this.dofScenesInfo?.get(calcType);

    // if (dofCalcInfo !== undefined && dofCalcInfo.pic) {
    //   this.calDof(dofCalcInfo.pic).then((result) => {
    //     if (!dofCalcInfo) {
    //       log.showWarn('dofCalcInfo is null.');
    //       return;
    //     }
    //
    //     dofCalcInfo.isDofDone = true;
    //     dofCalcInfo.isDof = result.isDof;
    //     dofCalcInfo.clockType = result.clockType;
    //     dofCalcInfo.configContent = FileUtil.getDofConfigStringByObj(dofCalcInfo);
    //     log.showWarn(`calDofByDisplay type is = ${calcType} isDof=${result.isDof} clockType:${dofCalcInfo.clockType}`);
    //     this.updateDofScenesInfo();
    //     if (needWriteConfigFile) {
    //       FileUtil.updateDofWallpaperConfig(dofCalcInfo);
    //     }
    //   })
    // }

    if (dofCalcInfo !== undefined && dofCalcInfo.pic) {
      this.calDof(dofCalcInfo.pic).then((result:ESObject) => {
        if (!dofCalcInfo) {
          log.showWarn('dofCalcInfo is null.');
          return;
        }

        dofCalcInfo.isDofDone = true;
        dofCalcInfo.isDof = result.isDof;
        dofCalcInfo.clockType = result.clockType;
        dofCalcInfo.configContent = FileUtil.getDofConfigStringByObj(dofCalcInfo);
        log.showWarn(`calDofByDisplay type is = ${calcType} isDof=${result.isDof} clockType:${dofCalcInfo.clockType}`);
        this.updateDofScenesInfo();
        if (needWriteConfigFile) {
          FileUtil.updateDofWallpaperConfig(dofCalcInfo);
        }
      })
    }
  }

  private updateDofScenesInfo(): void {
    slUiStateMgr.getSlState(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE)?.setSlState(
      DofWallpaperStaticStateType.DOF_TYPE_CONFIG, this.dofScenesInfo);
  }
}

// 单例
export let slDofHelper: DofHelper = new DofHelper();