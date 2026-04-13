/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { animateExBreak, animateExDelete, animateExToImmediately } from '@ohos/windowscene/Index';
import { CommonConstants } from '../../constants/CommonConstants';
import { editModeManager } from '../../editmode/model/EditModeManager';
import type abilityCommon from '@ohos.app.ability.common';

import {
  FolderDataModelManager
} from '../model/FolderDataModelManager'
import curves from '@ohos.curves';
import { FolderLayoutCacheManager, GridLayoutItemInfo, StyleConstants } from '../../TsIndex';
import { lockLayoutManager } from '../../manager/LockLayoutManager';


const TAG = 'FolderItemAnimateData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

// 网格宽为4
const GRID_WITH_4: number = 4;
const GRID_WITH_2: number = 2;

const ORIGIN_SCALE: ScaleOptions = { x: 1, y: 1 };
const SMALL_FOLDER_SCALE: ScaleOptions = { x: 0.9, y: 0.9 };
const BIG_FOLDER_DEFAULT_SCALE: ScaleOptions = { x: 0.95, y: 0.95 };
const BIG_FOLDER_4_2_SCALE: ScaleOptions = { x: 0.97, y: 0.97 };

export class FolderItemAnimateData {
  public folderBackgroundScaleX: number;
  public folderBackgroundScaleY: number;
  public folderComponentScale: ScaleOptions;
  private folderId: string;
  private desktopContext?: abilityCommon.ServiceExtensionContext = GlobalContext.getContext();

  constructor() {
    this.folderBackgroundScaleX = 1;
    this.folderBackgroundScaleY = 1;
    this.folderComponentScale = ORIGIN_SCALE;
    this.folderId = '';
  }

  /**
   * 赋值folderID
   * params folderId folderId
   */
  public initFoldAnimate(folderId: string): void {
    if (!CheckEmptyUtils.isEmpty(folderId)) {
      this.folderId = folderId as string;
    } else {
      log.showError(`FolderItemAnimateData folderId is undefined`);
      this.folderId = '';
    }
  }

  /**
   * 判断是否是小文件夹
   * @return boolean 是否是小文件夹
   */
  private isSmallFolder(): boolean {
    let folderDataModel = FolderDataModelManager.getInstance()
      .getFolderDataModelById(this.folderId);
    if (!folderDataModel) {
      return false;
    }
    return folderDataModel.isSmallFolder();
  }

  /**
   * 背板缩放动画
   * @param isFolderBackplaneOpen 是否缩放
   * @return boolean 是否是小文件夹
   */
  public showFolderBackplaneAnimate(isFolderBackplaneOpen: boolean): void {
    log.showInfo('showFolderBackplaneAnimate isFolderBackplaneOpen:%{public}s', isFolderBackplaneOpen);
    // 锁定布局时，拖拽快捷方式至文件夹，不显示背板缩放动效
    if (lockLayoutManager.isLockLayout()) {
      return;
    }
    try {
      if (isFolderBackplaneOpen) {
        animateTo({
          curve: curves.springMotion(0.414, 0.82, 0)
        }, () => {
          this.folderBackgroundScaleX = this.isSmallFolder() ? 1.1 : CommonConstants.ICON_DEFAULT_SCALE;
          this.folderBackgroundScaleY = this.isSmallFolder() ? 1.1 : CommonConstants.ICON_DEFAULT_SCALE;
        })
      } else {
        animateTo({
          curve: curves.springMotion(0.414, 0.82, 0)
        }, () => {
          this.folderBackgroundScaleX = 1.0;
          this.folderBackgroundScaleY = 1.0;
        })
      }
    } catch (error) {
      log.error('showFolderBackplaneAnimate: curves error', error);
    }
  }

  private getCurve(): curves.ICurve {
    return this.isSmallFolder() ? curves.springCurve(1, 1, 410, 38) : curves.springCurve(0.5, 1, 350, 35);
  }

  private getLongPressAnimationName(): string {
    return `folderLongPressAnimation-${this.folderId}`;
  }

  private getRestoreLongPressAnimationName(): string {
    return `folderRestoreLongPressAnimation-${this.folderId}`;
  }

  /**
   * 打断文件夹背板按压动画
   */
  public breakLongPressAnimation(): void {
    const animName: string = this.getLongPressAnimationName();
    animateExBreak(animName, 'breakLongPressAnimation');
    animateExDelete(animName);

    const restoreAnimName: string = this.getRestoreLongPressAnimationName();
    animateExBreak(restoreAnimName, 'breakLongPressAnimation');
    animateExDelete(restoreAnimName);

    this.unregisterIconTouchEvent();
  }

  /**
   * 文件夹背板按压动画
   *
   * @param isFolderComponentZoomOut 是否执行整体缩放动效
   */
  public playLongPressAnimation(isFolderComponentZoomOut: boolean): void {
    if (isFolderComponentZoomOut) {
      log.showInfo('folderComponentLongPress zoom out');
      try {
        // 需要保留按压动效场景不做打断
        this.desktopContext?.eventHub.on(`appIconLongPressEffectCancel`, (isNeedAnimate: boolean = false): void => {
          if (!isNeedAnimate) {
            this.restoreLongPressAnimation()
          } else {
            this.unregisterIconTouchEvent();
          }
        });
      } catch (err) {
        log.showError('eventHub on appIconLongPressEffectCancel error%{public}d:%{public}s', err.code, err.message);
      }

      const animName: string = this.getLongPressAnimationName();
      const animParam: AnimateParam = {
        duration: 400,
        curve: this.getCurve(),
        playMode: PlayMode.Normal,
      };
      animateExToImmediately(animName, animParam, () => {
        this.folderComponentScale = this.isSmallFolder() ? SMALL_FOLDER_SCALE : this.getBigFolderLongPressScale();
      }, () => {
        this.unregisterIconTouchEvent();
        animateExDelete(animName);
      });
    } else {
      this.restoreLongPressAnimation();
    }
  }

  private getBigFolderLongPressScale(): ScaleOptions {
    let folderInfo: GridLayoutItemInfo | undefined =
      FolderLayoutCacheManager.getInstance().selectGridLayoutItemByFolderId(this.folderId);
    if (!folderInfo) {
      return SMALL_FOLDER_SCALE;
    }
    return folderInfo.area && folderInfo.area[0] === GRID_WITH_4 && folderInfo.area[1] === GRID_WITH_2 ?
      BIG_FOLDER_4_2_SCALE : BIG_FOLDER_DEFAULT_SCALE;
  }

  private restoreLongPressAnimation(): void {
    if (this.folderComponentScale.x === 1 &&
      this.folderComponentScale.y === 1) {
      return;
    }
    log.showInfo('folderComponentLongPress zoom in');
    this.unregisterIconTouchEvent();
    const restoreAnimName: string = this.getRestoreLongPressAnimationName();
    const animParam: AnimateParam = {
      duration: 250,
      curve: this.getCurve(),
      playMode: PlayMode.Normal,
    };
    animateExToImmediately(restoreAnimName, animParam, () => {
      this.folderComponentScale = ORIGIN_SCALE;
    }, () => {
      animateExDelete(restoreAnimName);
    });
  }

  /**
   * 取消长按动画
   *
   * @param finishCallBack 回调函数
   */
  public cancelLongPressAnimation(finishCallBack: Function): void {
    log.showInfo('smallFolderIconLongPress animation cancel');
    animateTo({
      duration: 0,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.folderComponentScale = { x: StyleConstants.DEFAULT_1, y: StyleConstants.DEFAULT_1 };
        finishCallBack();
      }
    }, () => {
      this.folderComponentScale = {
        x: StyleConstants.CANCEL_LONG_PRESS_SCALE,
        y: StyleConstants.CANCEL_LONG_PRESS_SCALE
      };
    })
  }


  private unregisterIconTouchEvent(): void {
    try {
      this.desktopContext?.eventHub.off(`appIconLongPressEffectCancel`);
    } catch (err) {
      log.showError('eventHub off appIconLongPressEffectCancel %{public}d:%{public}s', err.code, err.message);
    }
  }
}

