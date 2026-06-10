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
  BaseObserverManager,
  CommonConstants,
  ContractedFolderLayoutViewModel,
  GridLayoutItemInfo,
  OBSERVER_TYPE,
  StyleConstants
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { curves } from '@kit.ArkUI';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { FolderCommonUtil } from '@ohos/launchercommon/src/main/ets/folder/next/common/FolderCommonUtil';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { animateExBreak, animateExDelete, animateExToImmediately } from '@ohos/windowscene/Index';
import { NumberConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';

const TAG: string = 'LongPressActionViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const ORIGIN_SCALE: ScaleOptions = { x: 1, y: 1 };
const SMALL_FOLDER_SCALE: ScaleOptions = { x: 0.9, y: 0.9 };
const BIG_FOLDER_4_2_SCALE: ScaleOptions = { x: 0.97, y: 0.97 };
const BIG_FOLDER_DEFAULT_SCALE: ScaleOptions = { x: 0.95, y: 0.95 };

/**
 * 长按动效的业务类：打断、删除、添加、播放动效
 */
export class LongPressActionViewModel {
  private mDesktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private toLongPressScale: ScaleOptions = ORIGIN_SCALE;

  /**
   * 开始文件夹动效
   *
   * @param folderId 文件夹id
   * @param isFolderComponentZoomOut
   */
  public startFolderAnimation(folderId: string, isFolderComponentZoomOut: boolean): void {
    log.showInfo('start to long press animation');
    let osrMgr: BaseObserverManager = ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId);
    let isSmallFolder: boolean = FolderCommonUtil.isLayout1X1ByFolderId(folderId);
    if (isFolderComponentZoomOut) {
      log.showInfo('folderComponentLongPress zoom out');
      try {
        this.mDesktopContext?.eventHub.on(`appIconLongPressEffectCancel`,
          (isNeedAnimate: boolean = false): void => {
            if (isNeedAnimate) {
              this.unregisterIconTouchEvent();
            } else {
              this.restoreLongPressAnimation(folderId, isSmallFolder, osrMgr);
            }
          });
      } catch (err) {
        log.showError('eventHub on appIconLongPressEffectCancel error%{public}d:%{public}s', err.code, err.message);
      }

      const animName: string = this.getLongPressAnimationName(folderId);
      const animParam: AnimateParam = {
        duration: 400,
        curve: this.getCurve(isSmallFolder),
        playMode: PlayMode.Normal,
      };
      animateExToImmediately(animName, animParam, () => {
        ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId)
          .getObserverUpdator('zoomOut-folder-scale', OBSERVER_TYPE.FOLDER_ICON).scale(this.toLongPressScale.x);
      }, () => {
        this.unregisterIconTouchEvent();
        animateExDelete(animName);
      });
    } else {
      this.restoreLongPressAnimation(folderId, isSmallFolder, osrMgr);
    }
  }

  private restoreLongPressAnimation(folderId: string, isSmall: boolean, osrMgr: BaseObserverManager): void {
    if (osrMgr.getObserverUpdator('get scale', OBSERVER_TYPE.FOLDER_ICON).getScale() === 1) {
      return;
    }
    log.showInfo('folderComponentLongPress zoom in');
    this.unregisterIconTouchEvent();
    const restoreAnimName: string = this.getRestoreLongPressAnimationName(folderId);
    const animParam: AnimateParam = {
      duration: 250,
      curve: this.getCurve(isSmall),
      playMode: PlayMode.Normal,
    };
    animateExToImmediately(restoreAnimName, animParam, () => {
      ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId)
        .getObserverUpdator('zoomIn-folder-scale', OBSERVER_TYPE.FOLDER_ICON).scale(ORIGIN_SCALE.x);
    }, () => {
      animateExDelete(restoreAnimName);
    });
  }

  /**
   * 文件夹名字动效
   *
   * @param folderId 文件夹id
   * @param isShow true执行显示动效，false执行隐藏动效
   */
  public startFolderNameAnimation(folderId: string, isShow: boolean): void {
    let curOpacity = isShow ? NumberConstants.CONSTANT_NUMBER_ZERO : NumberConstants.CONSTANT_NUMBER_ONE;
    ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId).setFolderNameOpacity('name-opacity-start', curOpacity);
    let toOpacity: number = isShow ? NumberConstants.CONSTANT_NUMBER_ONE : NumberConstants.CONSTANT_NUMBER_ZERO;
    const folderNameAnim: string = this.getFolderNameAnimationName(folderId);
    const animParam: AnimateParam = {
      duration: 200,
      curve: Curve.Linear,
    }
    animateExToImmediately(folderNameAnim, animParam,
      () => ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId).setFolderNameOpacity('name-opacity-end', toOpacity),
      () => animateExDelete(folderNameAnim));
  }

  /**
   * 打断文件夹背板按压动画
   */
  public breakLongPressAnimation(folderId: string): void {
    const animName: string = this.getLongPressAnimationName(folderId);
    animateExBreak(animName, 'breakLongPressAnimation');
    animateExDelete(animName);

    const restoreAnimName: string = this.getRestoreLongPressAnimationName(folderId);
    animateExBreak(restoreAnimName, 'breakLongPressAnimation');
    animateExDelete(restoreAnimName);
    this.unregisterIconTouchEvent();
  }

  /**
   * 取消长按动画
   *
   * @param finishCallBack 回调函数
   */
  public cancelLongPressAnimation(folderId: string): void {
    log.showInfo('smallFolderIconLongPress animation cancel');
    let layoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();
    animateTo({
      duration: 0,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        layoutVm.getViewOsrMgr(folderId).getObserverUpdator('finish-press', OBSERVER_TYPE.FOLDER_ICON)
          .scale(StyleConstants.DEFAULT_1);
        this.mDesktopContext?.eventHub.off(`otherIconLongPressEffectCancel`);
      }
    }, () => {
      layoutVm.getViewOsrMgr(folderId).getObserverUpdator('end-press', OBSERVER_TYPE.FOLDER_ICON)
        .scale(StyleConstants.CANCEL_LONG_PRESS_SCALE);
    })
  }

  /**
   * 设置文件夹名字透明度变化
   *
   * @param folderId 文件夹id
   * @param isShow 是否显示
   */
  public changeAppNameOpacity(folderId: string | undefined, isShow: boolean): void {
    let startOpacity: number = isShow ? NumberConstants.CONSTANT_NUMBER_ZERO : NumberConstants.CONSTANT_NUMBER_ONE;
    let endOpacity: number = isShow ? NumberConstants.CONSTANT_NUMBER_ONE : NumberConstants.CONSTANT_NUMBER_ZERO;
    ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId).setFolderNameOpacity('name-opacity-start', startOpacity);
    if (AppStorage.get<string>('device') === CommonConstants.DEFAULT_DEVICE_TYPE) {
      animateTo({
        duration: 200,
        curve: Curve.Linear,
      }, () => {
        ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId).setFolderNameOpacity('name-opacity-end', endOpacity);
      })
    }
  }

  /**
   * 设置按压动效的目标scale
   *
   * @param folder 文件夹
   */
  public setToLongPressScale(folder: GridLayoutItemInfo): void {
    if (FolderCommonUtil.isLayout1X1(folder.area)) {
      this.toLongPressScale = SMALL_FOLDER_SCALE;
      return;
    }
    this.toLongPressScale = FolderCommonUtil.isLayout4X2(folder.area) ? BIG_FOLDER_4_2_SCALE : BIG_FOLDER_DEFAULT_SCALE;
  }

  private getCurve(isSmallFolder: boolean): curves.ICurve {
    return isSmallFolder ? curves.springCurve(1, 1, 410, 38) : curves.springCurve(0.5, 1, 350, 35);
  }

  private getLongPressAnimationName(folderId: string): string {
    return `folderLongPressAnimation-${folderId}`;
  }

  private getRestoreLongPressAnimationName(folderId: string): string {
    return `folderRestoreLongPressAnimation-${folderId}`;
  }

  private getFolderNameAnimationName(folderId: string): string {
    return `folderNameAnimation_${folderId}`;
  }

  private unregisterIconTouchEvent(): void {
    try {
      this.mDesktopContext?.eventHub.off(`appIconLongPressEffectCancel`);
    } catch (err) {
      log.showError('eventHub off appIconLongPressEffectCancel %{public}d:%{public}s', err.code, err.message);
    }
  }
}