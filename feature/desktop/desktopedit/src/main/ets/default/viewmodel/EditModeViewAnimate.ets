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
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { curves } from '@kit.ArkUI';
import { EditModeConstants, editModeManager, EditModeUtils } from '@ohos/launchercommon';
import { EditModeStyleConfig } from '@ohos/launchercommon/src/main/ets/editmode/data/PageEditData';
import EditModeStyleConstants from '../common/constants/EditModeStyleConstants';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import { editModeViewManager } from '../manager/EditModeViewManager';
import { EditModeGridSwiperViewData } from '../data/EditModeGridSwiperViewData';
import { EditModeSingePageViewData } from '../data/EditModeSingePageViewData';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';

const TAG = 'EditModeViewAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 编辑模式动效
 */
export class EditModeViewAnimate {
  private editModeStyleConfig: EditModeStyleConfig = editModeManager.getEditModeStyleConfig();

  public async playEnterExitAnimate(isEnter: boolean): Promise<void> {
    await Promise.all([this.playGridSwiperAnimate(isEnter), this.playSinglePageAnimate(isEnter),
      this.playFolderBackgroundOpacityAnimate(isEnter)]);
  }

  public playGridSwiperAnimate(isEditMode: boolean): Promise<void> {
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    let swiperScale: number = 1;
    if (isEditMode) {
      swiperScale = EditModeUtils.calSwiperScale(screenWidth);
      let pageScale: number = EditModeUtils.calSinglePageScale(screenWidth);
      editModeManager.getEditModeViewData().setScale(swiperScale * pageScale);
    } else {
      editModeManager.getEditModeViewData().setScale(1);
    }
    EditModeUtils.setSwiperScale(swiperScale);
    return this.playGridSwiperScaleAnimate(isEditMode, swiperScale);
  }

  private playGridSwiperScaleAnimate(isEditMode: boolean, swiperScale: number, delay?: number): Promise<void> {
    return new Promise((resolve, reject) => {
      let bgBlurScale: number = 0;
      let desktopContext: ServiceExtensionContext = GlobalContext.getContext();
      let isDarkMode: boolean = desktopContext?.config?.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      let folderBgColor = isDarkMode ? '#00000000' : '#00FFFFFF';
      let backgroundColor = isDarkMode ? '#00FFFFFF' : '#00000000';
      if (isEditMode) {
        folderBgColor = isDarkMode ? '#33000000' : '#4DFFFFFF';
        if (SCBVisualEffectMgr.isFolderSolidColor()) {
          folderBgColor = isDarkMode ? '#802E3033' : '#99FAFAFA';
        }
        bgBlurScale = 1;
        backgroundColor = EditModeUtils.getEditModeWallpaperColor(isDarkMode);
      }
      let swiperViewData: EditModeGridSwiperViewData = editModeViewManager.getEditModeGridSwiperViewData();
      let prevNextMargin = isEditMode ? EditModeUtils.getPrevNextMargin() : 0;
      swiperViewData.setPrevNextMargin(prevNextMargin);
      log.showInfo(
        'gridSwiperScaleAnimate folderBg:%{public}s, swiperScale:%{public}d, bgBlurScale:%{public}d, bgColor:%{public}s',
        folderBgColor, swiperScale, bgBlurScale, backgroundColor);

      // 进入编辑模式时，gridSwiper延迟开始动效，singlePage先执行动效，产生间距
      animateTo({
        curve: EditModeConstants.CHANGE_DESKMODE_CURVE,
        delay: delay ?? isEditMode ? EditModeStyleConstants.DESKTOP_MODE_CHANGE_DELAY : 0,
        onFinish: resolve
      }, () => {
        swiperViewData.setGridSwiperScale(swiperScale);
        editModeViewManager.getEditModeWallpaperViewData().setWallpaperBackgroundBlurScale(bgBlurScale);
        editModeViewManager.getEditModeWallpaperViewData().setWallpaperBackgroundColor(backgroundColor);
        editModeManager.getEditModeFolderViewData().setFolderBackgroundColor(folderBgColor);
      });
    })
  }

  public async playExtensionPage(isShowExtensionUI: boolean): Promise<void> {
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    let pageScale = isShowExtensionUI ? 1 : EditModeUtils.calSinglePageScale(screenWidth);
    let pageBgOpacity = isShowExtensionUI ? 0 : this.editModeStyleConfig.swiperEditOpacity;
    let pageBgSaturate = isShowExtensionUI ? 1 : EditModeStyleConstants.SWIPER_EDIT_SATURATE;
    let swiperScale: number = isShowExtensionUI ? 1 : EditModeUtils.calSwiperScale(screenWidth);
    // 当前是否在编辑模式中
    let isInEditMode: boolean = editModeManager.isInEditMode();
    swiperScale = isInEditMode ? swiperScale : 1;
    pageScale = isInEditMode ? pageScale : 1;
    let pageOpacity = isShowExtensionUI ? 0 : 1;
    log.showWarn(`playExtensionPage isInEditMode:${isInEditMode} swiperScale:${swiperScale} pageScale:${pageScale}`);
    await Promise.all([
      this.playSinglePageScaleAnimateWithUIExtension(pageScale, pageOpacity, pageBgOpacity,
        pageBgSaturate, isShowExtensionUI),
      this.playGridSwiperScaleAnimate(isInEditMode, swiperScale, isShowExtensionUI ?
        0 : EditModeStyleConstants.ICON_EDIT_PAGE_DELAY)
    ])
  }

  public playSinglePageAnimate(isEditMode: boolean): Promise<void> {
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    let pageBgOpacity = isEditMode ? this.editModeStyleConfig.swiperEditOpacity : 0;
    let pageBgSaturate = isEditMode ? EditModeStyleConstants.SWIPER_EDIT_SATURATE : 1;
    let pageScale = isEditMode ? EditModeUtils.calSinglePageScale(screenWidth) : 1;
    let pageOpacity = 1;
    EditModeUtils.setPageScale(pageScale);
    return this.playSinglePageScaleAnimate(isEditMode, pageScale, pageOpacity, pageBgOpacity, pageBgSaturate);
  }

  private playFolderBackgroundOpacityAnimate(isEditMode: boolean): void {
    let opacity: number = isEditMode ? 1 : 0;
    editModeManager.getEditModeFolderViewData().setFolderBackgroundOpacity(opacity);
    log.showInfo(`playFolderBackgroundOpacityAnimate, isEditMode: ${isEditMode}`);
  }

  private playSinglePageScaleAnimateWithUIExtension(
    pageScale: number,
    pageOpacity: number,
    pageBgOpacity: number,
    pageBgSaturate: number,
    isShowExtensionUI?: boolean): Promise<void> {
    return new Promise((resolve, reject) => {
      animateTo({
        duration: 350,
        delay: isShowExtensionUI ? 0 : EditModeStyleConstants.ICON_EDIT_PAGE_DELAY,
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
        onFinish: resolve
      }, () => {
        let singePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
        singePageViewData.setSingePageSwiperScale(pageScale);
        singePageViewData.setOpacity(pageOpacity);
        singePageViewData.setSingePageBackgroundOpacity(pageBgOpacity);
        singePageViewData.setSingePageBackgroundSaturate(pageBgSaturate);
      });
    })
  }

  private playSinglePageScaleAnimate(
    isEditMode: boolean,
    pageScale: number,
    pageOpacity: number,
    pageBgOpacity: number,
    pageBgSaturate: number): Promise<void> {
    log.showInfo('singlePageScaleAnimate pageScale: %{public}d, pageScale: %{public}d, pageBgOpacity: %{public}d',
      pageScale, pageScale, pageBgOpacity, pageBgSaturate);
    return new Promise((resolve, reject) => {
      // 流光动效时取消编辑模式的动画
      let mattesPanelShow: boolean = AppStorage.get<boolean>('mattesPanelShow') as boolean;
      if (mattesPanelShow || (DeviceHelper.isThreeFoldProduct() && !isEditMode)) {
        let singePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
        singePageViewData.setSingePageSwiperScale(pageScale);
        singePageViewData.setOpacity(pageOpacity);
        singePageViewData.setSingePageBackgroundOpacity(pageBgOpacity);
        singePageViewData.setSingePageBackgroundSaturate(pageBgSaturate);
        resolve();
        return;
      }
      // 退出编辑模式时，singlePage延迟退出，保持间距
      animateTo({
        curve: EditModeConstants.CHANGE_DESKMODE_CURVE,
        delay: isEditMode ? 0 : EditModeStyleConstants.DESKTOP_MODE_CHANGE_DELAY,
        onFinish: () => {
          // 因为退出编辑模式这个当前动效延迟触发，所以该动效结束时代表退出编辑模式结束
          resolve();
        }
      }, () => {
        let singePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
        singePageViewData.setSingePageSwiperScale(pageScale);
        singePageViewData.setOpacity(pageOpacity);
        singePageViewData.setSingePageBackgroundOpacity(pageBgOpacity);
        singePageViewData.setSingePageBackgroundSaturate(pageBgSaturate);
      });
    })
  }
}