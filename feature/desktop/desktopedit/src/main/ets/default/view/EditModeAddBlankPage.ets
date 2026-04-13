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
import { AccessibilityManager, DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import {
  EditModeUtils,
  EventConstants,
  StyleConstants,
  EditModeConstants,
  DeviceState,
  GridLayoutUtil,
  editModeManager,
  PageDesktopModel
} from '@ohos/launchercommon';
import { EditModeStyleConfig } from '@ohos/launchercommon/src/main/ets/editmode/data/PageEditData';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { EditModeBlankPageViewParams, editModeViewManager } from '../manager/EditModeViewManager';
import { EditModeSingePageViewData } from '../data/EditModeSingePageViewData';
import { pageEditManager, EditModePageActionEnum, PageEditViewModel, PageDragManager } from '@ohos/launchercommon/Index';
import { DragEventManager, DragEventCallback } from '@ohos/componentdrag';
import { desktopUtil, RTLUtil } from '@ohos/componenthelper';
import { SwiperPageWhiteBoxComponent } from './SwiperPageWhiteBoxComponent';
import lazy OuterEditConstants from '../common/constants/OuterEditConstants';
import { EditModeAccessibilityUtil } from '@ohos/launchercommon/src/main/ets/editmode/utils/EditModeAccessibilityUtil';
import { SwiperLoadData } from '@ohos/swiperdata';
import accessibility from '@ohos.accessibility';

const TAG: string = 'EditModeAddPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 编辑模式右侧添加按钮页
 */
@Component
export struct EditModeAddPage {
  @Prop singleContext?: SingleContext;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private gridSwiperScale: number = EditModeUtils.getSwiperScale();
  private isOuterDesktop: boolean = false;
  @State editModeSingePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
  @State translateX: number = 0;
  @State opacityWhenMaxPage: number = 1;
  private mDragEventCallback: DragEventCallback = {};
  private itemKey: string = '';
  @StorageLink('folderStatus') folderStatus: number = DeviceState.DEFAULT_STATE;
  @State mFoldPaddingRight: number = 0;
  @State mFoldPaddingLeft: number = 0;
  @StorageLink('isPortrait') mIsPortrait: boolean = true;
  @Prop @Watch('indexInSwiperChange') indexInSwiper: number = 0;
  @State indexForWhiteBoxLeft: number = 0;
  @State indexForWhiteBoxRight: number = 0;
  private blankPageViewParams: EditModeBlankPageViewParams = new EditModeBlankPageViewParams();
  private translateY: number = this.editModeSingePageViewData.getEditModeBgTranslateY();
  private onPageIndexShowedChange: Function = (): void => this.updateAccessibilityFocusable();
  private editModeStyleConfig: EditModeStyleConfig = editModeManager.getEditModeStyleConfig();
  @State mAccessibilityFocusable: boolean = false;
  @State isHover: boolean = false;

  private isCircleButtonStyle(): boolean {
    return this.editModeStyleConfig.addPageButtonStyle === 'CircleButton';
  }

  updateAccessibilityFocusable() {
    const isAccessibilityMode: boolean = AccessibilityManager.getInstance().getIsAccessibilityMode();
    if (isAccessibilityMode) {
      const pages: number[] = SwiperLoadData.getInstance().getPages();
      this.mAccessibilityFocusable = desktopUtil.getPageIndexValue(this.isOuterDesktop) >= pages.length;
      if (this.mAccessibilityFocusable) {
        try {
          let eventInfo: accessibility.EventInfo = ({
            type: 'requestFocusForAccessibilityNotInterrupt',
            bundleName: 'com.ohos.sceneboard',
            triggerAction: 'common',
            customId: 'editModeAddBlankPage'
          });
          accessibility.sendAccessibilityEvent(eventInfo);
          log.showInfo('requestFocus: editModeAddBlankPage');
        } catch {
          log.showError('requestFocus error');
        }
      }
    }
  }

  aboutToAppear(): void {
    this.blankPageViewParams = editModeViewManager.getBlankPageViewParams(this.isOuterDesktop);
    this.initConfig();
    this.indexInSwiperChange();
    if (this.isOuterDesktop) {
      this.translateY = OuterEditConstants.ADD_BLANK_PAGE_TRANSLATE_Y;
    }
    this.itemKey = PageDragManager.getInstance().getPageUniqueKey(Number.MAX_VALUE);
    this.mDragEventCallback = {
      onStartSqueezedEvent: (translatePosition: number[][]): void => {
        if (translatePosition == null) {
          log.showError('onStartSqueezedEvent with invalid error');
          return;
        }
        const translateX: number = translatePosition[1][0] - translatePosition[0][0];
        log.showInfo('onStartSqueezedEvent key:%{public}s translateX:%{public}d', this.itemKey, translateX);
        animateTo({
          duration: EditModeConstants.PAGE_SQUEEZE_DURATION,
          delay: PageEditViewModel.getInstance().getPageEditAnimateDelayTime(),
          curve: EditModeConstants.PAGE_SQUEEZE_CURVE,
        }, () => {
          if (RTLUtil.isRTL()) {
            this.translateX = -translateX;
          } else {
            this.translateX = translateX;
          }
          if (PageEditViewModel.getInstance().isAddingLastPage(this.isOuterDesktop)) {
            this.opacityWhenMaxPage = 0;
          }
        });
      },
      onCancelSqueezedEvent: (): void => {
        log.showInfo('onCancelSqueezedEvent key:%{public}s withAnimation:%{public}s', this.itemKey);
        this.translateX = 0;
      }
    };
    DragEventManager.getInstance(this.isOuterDesktop).registerDragEvent(this.mDragEventCallback, this.itemKey);
    if (pageEditManager.editModeEditPageData.deletingLastBlankPage) {
      log.showInfo(`deletingLastBlankPage ${pageEditManager.editModeEditPageData.deletingLastBlankPage}`);
      this.addPageShowAnimateWhenDeleteLastPage();
    }
    this.desktopContext?.eventHub.on(EventConstants.EVENT_UPDATE_PAGE_FOCUS, this.onPageIndexShowedChange);
  }

  addPageShowAnimateWhenDeleteLastPage() {
    pageEditManager.editModeEditPageData.deletingLastBlankPage = false;
    if (RTLUtil.isRTL()) {
      this.translateX = -PageEditViewModel.getInstance().getScreenXTranslate();
    } else {
      this.translateX = PageEditViewModel.getInstance().getScreenXTranslate();
    }
    this.opacityWhenMaxPage = 0;
    animateTo({
      duration: EditModeConstants.PAGE_SQUEEZE_DURATION,
      curve: EditModeConstants.PAGE_SQUEEZE_CURVE,
    }, () => {
      this.translateX = 0;
      this.opacityWhenMaxPage = 1;
    });
  }

  aboutToDisappear(): void {
    this.opacityWhenMaxPage = 1;
    DragEventManager.getInstance(this.isOuterDesktop).unRegisterDragEvent(this.mDragEventCallback, this.itemKey);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_UPDATE_PAGE_FOCUS, this.onPageIndexShowedChange);
  }

  private initConfig() {
    this.folderStatus = (AppStorage.get('folderStatus') ?? DeviceState.DEFAULT_STATE) as number;
    this.paddingSideUpdate();
  }

  private paddingSideUpdate() {
    let indexInSwiper = this.indexInSwiper ?? 0;
    if (this.folderStatus === DeviceState.DEFAULT_STATE) {
      this.mFoldPaddingRight = 0;
      this.mFoldPaddingLeft = 0;
    } else {
      if (indexInSwiper % 2 === 0) {
        this.mFoldPaddingLeft = PageDesktopModel.getInstance().getPageDesktopStyleConfig()
          .mFoldPaddingSide as number;
        this.mFoldPaddingRight = 0;
      } else {
        this.mFoldPaddingLeft = 0;
        this.mFoldPaddingRight = PageDesktopModel.getInstance().getPageDesktopStyleConfig()
          .mFoldPaddingSide as number;
      }
    }
  }

  indexInSwiperChange() {
    this.indexForWhiteBoxRight = RTLUtil.isRTL() ? this.indexInSwiper : this.indexInSwiper + 1;
    this.indexForWhiteBoxLeft = RTLUtil.isRTL() ? this.indexInSwiper + 1 : this.indexInSwiper;
    this.updateAccessibilityFocusable();
  }

  private getAddPageWidth(): number | string {
    if (this.isOuterDesktop) {
      return StyleConstants.PERCENTAGE_100;
    }
    return PageEditViewModel.getInstance().getScreenXTranslate();
  }

  @Styles
  pageEditButtonBgStyle() {
    .width(this.editModeStyleConfig.pageEditButtonSize)
    .height(this.editModeStyleConfig.pageEditButtonSize)
    .borderRadius(this.editModeStyleConfig.pageEditButtonSize / 2)
    .backgroundColor(this.isHover ? this.editModeStyleConfig.pageEditButtonHoverBgColor :
      editModeViewManager.isDarkWallPaper() ?
      this.editModeStyleConfig.pageEditButtonDarkBgColor :
      this.editModeStyleConfig.pageEditButtonBgColor
    )
    .border(this.editModeStyleConfig.addEditButtonBorderOptions)
    .hoverEffect(this.isCircleButtonStyle() ? HoverEffect.Scale : HoverEffect.None)
    .opacity(editModeViewManager.isDarkWallPaper() ? this.editModeStyleConfig.pageEditButtonDeepBgOpacity : 1)
  }


  @Builder
  addPageButton() {
    Stack() {
      if (this.isCircleButtonStyle()) {
        Button({ type: ButtonType.Circle, stateEffect: false }) {
          SymbolGlyph($r('sys.symbol.plus'))
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
          SymbolSpan($r('sys.symbol.plus'))
            .fontSize(`${this.editModeStyleConfig.pageEditButtonIconSize}vp`)
            .fontWeight(FontWeight.Normal)
            .renderingStrategy(SymbolRenderingStrategy.SINGLE)
            .fontColor([Color.White])
        }
      }
    }
    .opacity(this.editModeSingePageViewData.getOpacity())
    .responseRegion({ x: '-5%', y: '-5%', width: '110%', height: '110%' })
    .clickEffect(this.editModeStyleConfig.pageEditButtonClickEffect)
    .width(this.editModeStyleConfig.pageEditButtonSize)
    .height(this.editModeStyleConfig.pageEditButtonSize)
    .scale({
      x: 1 / EditModeUtils.getDesktopScale(),
      y: 1 / EditModeUtils.getDesktopScale(),
    })
    .onHover(this.isCircleButtonStyle() ? (isHover: boolean) => {
      this.isHover = isHover;
    } : () => {
    })
    .alignSelf(ItemAlign.Center)
    .onClick(() => {
      if (pageEditManager.editModeEditPageData.handleEditPageState === EditModePageActionEnum.WAITTING_ACTION) {
        this.desktopContext?.eventHub.emit(EventConstants.EDIT_BLANK_PAGE_IN_EDIT_MODE,
          EditModePageActionEnum.ADDING_BLANK_PAGE);
      }
    })
    .accessibilityDescription(EditModeAccessibilityUtil.getAddButtonAccessibilityText())
    .accessibilityNextFocusId(EditModeAccessibilityUtil.getEditModeDockIconId(0))
  }

  build() {
    Stack() {
      SwiperPageWhiteBoxComponent({
        singleContext: this.singleContext,
        folderStatus: this.folderStatus,
        mFoldPaddingRight: this.mFoldPaddingRight,
        mFoldPaddingLeft: this.mFoldPaddingLeft,
        mIsPortrait: this.mIsPortrait,
        indexInSwiper: this.indexForWhiteBoxLeft,
        getIndexInSwiper: (): number => this.indexForWhiteBoxLeft,
        isOuterDesktop: this.isOuterDesktop
      })
      if (GridLayoutUtil.isLargeFoldOrTrifoldExpanded()) {
        SwiperPageWhiteBoxComponent({
          singleContext: this.singleContext,
          folderStatus: this.folderStatus,
          mFoldPaddingRight: this.mFoldPaddingLeft,
          mFoldPaddingLeft: this.mFoldPaddingRight,
          mIsPortrait: this.mIsPortrait,
          indexInSwiper: this.indexForWhiteBoxRight,
          getIndexInSwiper: (): number => this.indexForWhiteBoxRight,
          isOuterDesktop: this.isOuterDesktop,
          isAddBlankPage: true,
        })
      }

      Row() {
      }
      .id('editModeAddBlankPage')
      .width(this.blankPageViewParams.bgWidth)
      .height(this.blankPageViewParams.bgHeight)
      .backgroundColor(this.editModeStyleConfig.pageEditBgColor)
      .opacity(this.editModeSingePageViewData.getSingePageBackgroundOpacity())
      .saturate(this.editModeSingePageViewData.getSingePageBackgroundSaturate())
      .borderRadius(this.blankPageViewParams.bgBorderRadius)
      .translate({ y: this.translateY })
      .accessibilityDescription(EditModeAccessibilityUtil.getAddPageAccessibilityText())
      this.addPageButton()
    }
    .align(Alignment.Center)
    .width(this.getAddPageWidth())
    .translate({ x: this.translateX })
    .opacity(this.opacityWhenMaxPage)
    .scale({
      x: this.editModeSingePageViewData.getSingePageSwiperScale(),
      y: this.editModeSingePageViewData.getSingePageSwiperScale(),
      centerX: StyleConstants.PERCENTAGE_50,
      centerY: StyleConstants.PERCENTAGE_50,
    })
    .accessibilityLevel('no')
    // 点击加号页背板空白处时，消费单击事件，防止透传到GridSwiper导致退出编辑模式
    .gesture(
      TapGesture()
    )
    .accessibilityLevel(this.mAccessibilityFocusable ? 'no' : 'no-hide-descendants')
  }
}