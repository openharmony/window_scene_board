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

import { LogDomain, Logger } from '@ohos/basicutils';
import { AccessibilityManager, DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import {
  EditModeConstants as cEditModeConstants,
  editModeManager,
  EditModeUtils,
  LayoutViewModel,
  PageInfoManager,
  StyleConstants
} from '@ohos/launchercommon';
import { EditModeStyleConfig } from '@ohos/launchercommon/src/main/ets/editmode/data/PageEditData';
import { EditModeConstants } from '../common/constants/EditModeConstants';
import { EditModeBlankPageViewParams, editModeViewManager } from '../manager/EditModeViewManager';
import { DisplayCountViewModel, PageEditViewModel } from '@ohos/launchercommon/Index';
import { RTLUtil } from '@ohos/componenthelper';
import { EditModeAccessibilityUtil } from '@ohos/launchercommon/src/main/ets/editmode/utils/EditModeAccessibilityUtil';
import IconEditPageConstants from '../common/constants/IconEditPageConstants';
import { EditModeExtensionData } from '../data/EditModeExtensionData';
import { IconEditWantData } from '../data/IconEditWantData';
import { EditModeSingePageViewData } from '../data/EditModeSingePageViewData';
import { ResUtils } from '@ohos/windowscene';
import { SwiperLoadData } from '@ohos/swiperdata';

const TAG: string = 'EditModeHomePageButton';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 设置主屏按钮
 */
@Component
export struct EditModeHomePageButton {
  @Prop index: number = 0;
  @Prop swiperKey: number = 0;
  @Prop gridHeight: number = 0;
  @Link homeSwiperKey: number;
  private translateX: number = 0;
  private translateY: number = 0;
  @State editModeFolderOpacity: number = 1;
  @StorageProp('editModeFolderBlurEffect') @Watch('notifyEditModeFolderBlurEffect')
  editModeFolderBlurEffectValue: boolean = false;
  @State editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
  @State iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
  @State editModeSingePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
  private editModeStyleConfig: EditModeStyleConfig = editModeManager.getEditModeStyleConfig();
  private blankPageViewParams: EditModeBlankPageViewParams = new EditModeBlankPageViewParams();

  aboutToAppear(): void {
    this.blankPageViewParams = editModeViewManager.getBlankPageViewParams();
    const displayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    if (displayCount === StyleConstants.DEFAULT_2) {
      this.translateX = -1 * (AppStorage.get<number>('screenWidth') as number) / 4;
    }
    if (RTLUtil.isRTL()) {
      this.translateX = -this.translateX;
    }
    this.translateY = this.getBtnCenterTranslateY();
  }

  /**
   * 获取按钮中心点偏移
   *
   * @returns 中心点偏移
   */
  private getBtnCenterTranslateY(): number {
    let screenWidth: number = AppStorage.get<number>('screenWidth') as number;
    let screenHeight: number = AppStorage.get<number>('screenHeight') as number;
    let workSpaceHeight: number = AppStorage.get<number>('workSpaceHeight') as number;
    // 背景板高度
    let bgHeight: number = EditModeUtils.getBackgroundHeight(screenHeight, screenWidth, workSpaceHeight);
    // swiper高度
    let swiperHeight = workSpaceHeight - LayoutViewModel.getInstance().getSysUITopHeight();
    if (!DeviceHelper.isPhone()) {
      swiperHeight = swiperHeight * (screenHeight - StyleConstants.SMART_DOCK_MARGIN_TOP) / screenHeight;
    }
    // 背景板中心相对stack中心偏移量
    let editModeBgTranslateY = this.editModeSingePageViewData.getEditModeBgTranslateY();
    // bg顶边
    let bgTop: number = editModeBgTranslateY - bgHeight / 2;
    return bgTop + PageEditViewModel.getInstance().getOneThirdSpace() +
      (cEditModeConstants.HOME_PAGE_BUTTON_SIZE / 2) / this.editModeStyleConfig.swiperEditScaleRate;
  }

  private notifyEditModeFolderBlurEffect(): void {
    animateTo({
      duration: 200,
      curve: Curve.Smooth
    }, () => {
      this.editModeFolderOpacity = this.editModeFolderBlurEffectValue ? 0 : 1;
    });
  }

  private editModeSingePageViewDataGetOpacity(): number {
    // 拉起图标编辑的场景，会对SwiperPage做透明度
    if (this.editModeExtensionData.isShowUIExtension() &&
      this.iconEditWantData.getExtensionWant()?.abilityName == IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME) {
      return this.editModeSingePageViewData.getOpacity();
    }
    return this.editModeFolderOpacity;
  }

  /**
   * 获取按钮背景颜色
   *
   * @returns 背景颜色
   */
  private getBgColor(): ResourceColor {
    // 主页高亮白色
    if (PageInfoManager.getInstance().isHomePage(this.index, this.homeSwiperKey)) {
      return Color.White;
    }
    // 深色壁纸
    if (editModeViewManager.isDarkWallPaper()) {
      return $r('sys.color.ohos_id_color_background');
    }
    // 浅色壁纸
    return EditModeConstants.PAGE_EDIT_BUTTON_BG_COLOR;
  }

  /**
   * 获取按钮背景透明度
   *
   * @returns 透明度
   */
  private getBgOpacity(): number {
    // 主屏时按钮不透明
    if (PageInfoManager.getInstance().isHomePage(this.index, this.homeSwiperKey)) {
      return 1;
    }
    // 深色壁纸
    if (editModeViewManager.isDarkWallPaper()) {
      return EditModeConstants.PAGE_EDIT_BUTTON_DEEP_BG_OPACITY;
    }
    // 浅色壁纸
    return 1;
  }

  @Styles
  pageEditButtonBgStyle() {
    .width(`${cEditModeConstants.HOME_PAGE_BUTTON_SIZE}vp`)
    .height(`${cEditModeConstants.HOME_PAGE_BUTTON_SIZE}vp`)
    .borderRadius(this.blankPageViewParams.buttonSize / 2)
    .backgroundColor(this.getBgColor())
    .opacity(this.getBgOpacity())
  }

  build() {
    Stack() {
      Row() {
      }
      .pageEditButtonBgStyle()

      Text() {
        SymbolSpan(PageInfoManager.getInstance().isHomePage(this.index, this.homeSwiperKey) ?
        $r('sys.symbol.house_fill') : $r('sys.symbol.house'))
          .fontSize(`${cEditModeConstants.HOME_PAGE_BUTTON_SIZE / 2}vp`)
          .fontWeight(FontWeight.Normal)
          .renderingStrategy(SymbolRenderingStrategy.SINGLE)
          .fontColor([PageInfoManager.getInstance().isHomePage(this.index, this.homeSwiperKey) ?
          $r('sys.color.ohos_id_color_emphasize') : Color.White])
      }
    }
    .responseRegion({
      x: '-5%',
      y: '-5%',
      width: '110%',
      height: '110%'
    })
    .clickEffect(this.editModeStyleConfig.pageEditButtonClickEffect)
    .onClick(() => {
      log.showInfo(TAG, 'click homePageButton');
      if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
        AccessibilityManager.getInstance()
          .sendTextAnnouncedForAccessibility(
            ResUtils.getInnerString($r('app.string.homepage_set')),
            'announceForIconEditPageIcon'
          );
      }
      if (PageInfoManager.getInstance().isHomePage(this.index, this.homeSwiperKey)) {
        return;
      }
      let displayCount: number = DisplayCountViewModel.getInstance().getDisplayCount();
      let newHomePageIndex: number = Math.floor(this.index / displayCount) * displayCount;
      PageInfoManager.getInstance()
        .setHomePageIndex(newHomePageIndex, LayoutViewModel.getInstance().isSimpleLauncherMode());
      this.homeSwiperKey = SwiperLoadData.getInstance().getSwiperKeyByIndex(newHomePageIndex);
    })
    .scale({
      x: 1 / this.editModeStyleConfig.swiperEditScaleRate,
      y: 1 / this.editModeStyleConfig.swiperEditScaleRate,
    })
    .alignSelf(ItemAlign.End)
    .translate({ x: this.translateX, y: this.translateY })
    .opacity(this.editModeSingePageViewDataGetOpacity())
    .accessibilityDescription(PageInfoManager.getInstance().isHomePage(this.index, this.homeSwiperKey) ?
    GlobalContext.getContext()?.resourceManager.getStringSync($r('app.string.homepage_set').id) :
    GlobalContext.getContext()?.resourceManager.getStringSync($r('app.string.homepage_set_button').id))
    .accessibilityNextFocusId(EditModeAccessibilityUtil.getEditModeDockIconId(0))
  }
}