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

import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import {
  editModeManager,
  EditModeUtils,
  EventConstants,
  LayoutViewModel,
  StyleConstants
} from '@ohos/launchercommon';
import { EditModeStyleConfig } from '@ohos/launchercommon/src/main/ets/editmode/data/PageEditData';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { EditModeBlankPageViewParams, editModeViewManager } from '../manager/EditModeViewManager';
import {
  pageEditManager,
  EditModePageActionEnum,
  DisplayCountViewModel
} from '@ohos/launchercommon/Index';
import { RTLUtil } from '@ohos/componenthelper';
import lazy OuterEditConstants from '../common/constants/OuterEditConstants';
import { EditModeAccessibilityUtil } from '@ohos/launchercommon/src/main/ets/editmode/utils/EditModeAccessibilityUtil';
import IconEditPageConstants from '../common/constants/IconEditPageConstants';
import { EditModeExtensionData } from '../data/EditModeExtensionData';
import { IconEditWantData } from '../data/IconEditWantData';
import { EditModeSingePageViewData } from '../data/EditModeSingePageViewData';

const TAG: string = 'EditModeDeleteBlankPageButton';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 编辑模式空白页删除按钮
 */
@Component
export struct EditModeDeleteBlankPageButton {
  @Prop index: number = 0;
  @Prop swiperKey: number = 0;
  @Prop singleContext?: SingleContext;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private translateX: number = 0;
  private translateY: number = 0;
  private isOuterDesktop: boolean = false;
  @State editModeExtensionData: EditModeExtensionData = editModeViewManager.getEditModeExtensionData();
  @State iconEditWantData: IconEditWantData = editModeViewManager.getIconEditWantData();
  @State editModeSingePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
  private blankPageViewParams: EditModeBlankPageViewParams = new EditModeBlankPageViewParams();
  private editModeStyleConfig: EditModeStyleConfig = editModeManager.getEditModeStyleConfig();
  @State isHover: boolean = false;

  aboutToAppear(): void {
    this.blankPageViewParams = editModeViewManager.getBlankPageViewParams(this.isOuterDesktop);
    const displayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    if (displayCount === StyleConstants.DEFAULT_2) {
      this.translateX = -1 * (AppStorage.get<number>('screenWidth') as number) / 4;
    }
    if (RTLUtil.isRTL()) {
      this.translateX = -this.translateX;
    }
    const screenHeight = AppStorage.get<number>('screenHeight') as number;
    const workSpaceHeight = AppStorage.get<number>('workSpaceHeight') as number;
    let addHeight: number = EditModeUtils.getBackplaneAddHeight() / this.editModeStyleConfig.swiperEditScaleRate;
    let swiperHeight = workSpaceHeight - LayoutViewModel.getInstance(this.singleContext).getSysUITopHeight();
    if (!DeviceHelper.isPhone()) {
      swiperHeight = swiperHeight * (screenHeight - StyleConstants.SMART_DOCK_MARGIN_TOP) / screenHeight;
    }
    const editModeHeight = swiperHeight + addHeight;
    if (this.isOuterDesktop) {
      this.blankPageViewParams.iconSize = OuterEditConstants.PAGE_EDIT_BUTTON_ICON_SIZE;
      this.blankPageViewParams.buttonSize = OuterEditConstants.PAGE_EDIT_BUTTON_SIZE;
      let screenWidth: number = AppStorage.get<number>('screenWidth') as number;
      this.translateY = (OuterEditConstants.BG_TRANSLATE_Y *
      this.editModeStyleConfig.swiperEditScaleRate +
        EditModeUtils.getOuterBackgroundSize(screenWidth) * this.editModeStyleConfig.swiperEditScaleRate / 2 -
        this.blankPageViewParams.buttonSize / 2 -
      this.editModeStyleConfig.pageEditDeleteIconMarginBottom) / this.editModeStyleConfig.swiperEditScaleRate;
    } else {
      this.translateY = (editModeViewManager.getEditModeSingePageViewData().getEditModeBgTranslateY() *
      this.editModeStyleConfig.swiperEditScaleRate +
        (this.editModeStyleConfig.swiperEditScaleRate * editModeHeight) / 2 -
        this.editModeStyleConfig.pageEditButtonSize / 2 -
      this.editModeStyleConfig.pageEditDeleteIconMarginBottom) / this.editModeStyleConfig.swiperEditScaleRate;
    }
  }

  private isCircleButtonStyle(): boolean {
    return this.editModeStyleConfig.addPageButtonStyle === 'CircleButton';
  }

  private editModeSingePageViewDataGetOpacity(): number {
    // 拉起图标编辑的场景，会对SwiperPage做透明度
    if (this.editModeExtensionData.isShowUIExtension() &&
      this.iconEditWantData.getExtensionWant()?.abilityName == IconEditPageConstants.EDIT_MODE_ICON_ABILITY_NAME) {
      return this.editModeSingePageViewData.getOpacity();
    }
    return 1;
  }

  @Styles
  pageEditButtonBgStyle() {
    .width(this.blankPageViewParams.buttonSize)
    .height(this.blankPageViewParams.buttonSize)
    .borderRadius(this.blankPageViewParams.buttonSize / 2)
    .backgroundColor(
      this.isHover ? this.editModeStyleConfig.pageEditButtonHoverBgColor :
      editModeViewManager.isDarkWallPaper() ?
      this.editModeStyleConfig.pageEditButtonDarkBgColor :
      this.editModeStyleConfig.pageEditButtonBgColor
    )
    .border(this.editModeStyleConfig.addEditButtonBorderOptions)
    .hoverEffect(this.isCircleButtonStyle() ? HoverEffect.Scale : HoverEffect.None)
    .opacity(editModeViewManager.isDarkWallPaper() ? this.editModeStyleConfig.pageEditButtonDeepBgOpacity : 1)
  }

  build() {
    Stack() {
      if (this.isCircleButtonStyle()) {
        Button({ type: ButtonType.Circle, stateEffect: false }) {
          SymbolGlyph($r('sys.symbol.xmark'))
            .fontSize(`${this.editModeStyleConfig.pageEditButtonIconSize}vp`)
            .fontWeight(FontWeight.Normal)
            .renderingStrategy(SymbolRenderingStrategy.SINGLE)
            .fontColor([Color.White])
        }
        .pageEditButtonBgStyle()
      } else {
        Row() {
        }
        .pageEditButtonBgStyle()
        Text() {
          SymbolSpan($r('sys.symbol.xmark'))
            .fontSize(`${this.blankPageViewParams.iconSize}vp`)
            .fontWeight(FontWeight.Normal)
            .renderingStrategy(SymbolRenderingStrategy.SINGLE)
            .fontColor([Color.White])
        }
      }
    }
    .responseRegion({ x: '-5%', y: '-5%', width: '110%', height: '110%' })
    .clickEffect(this.editModeStyleConfig.pageEditButtonClickEffect)
    .onClick(() => {
      log.showInfo('click deletePageButton');
      if (pageEditManager.editModeEditPageData.handleEditPageState === EditModePageActionEnum.WAITTING_ACTION) {
        this.desktopContext?.eventHub.emit(EventConstants.EDIT_BLANK_PAGE_IN_EDIT_MODE,
          EditModePageActionEnum.DELETEING_BLANK_PAGE, this.swiperKey, this.index);
      }
    })
    .onHover(this.isCircleButtonStyle() ? (isHover: boolean) => {
      this.isHover = isHover;
    } : () => {
    })
    .scale({
      x: 1 / this.editModeStyleConfig.swiperEditScaleRate,
      y: 1 / this.editModeStyleConfig.swiperEditScaleRate,
    })
    .alignSelf(ItemAlign.End)
    .translate({ x: this.translateX, y: this.translateY })
    .opacity(this.editModeSingePageViewDataGetOpacity())
    .accessibilityDescription(EditModeAccessibilityUtil.getDeleteButtonAccessibilityText())
    .accessibilityNextFocusId(EditModeAccessibilityUtil.getEditModeDockIconId(0))
  }
}