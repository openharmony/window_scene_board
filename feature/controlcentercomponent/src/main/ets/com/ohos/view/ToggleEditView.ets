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

import { AlertDialog } from '@ohos.arkui.advanced.Dialog';
import uiEffect from '@ohos.graphics.uiEffect';
import { ToggleEditType, ToggleEditViewData } from '../vm/ToggleEditViewData';
import { ToggleButtonType, ToggleEditViewModel, CollapseLibraryType } from '../vm/ToggleEditViewModel';
import { DevHelper } from '../common/DevHelper';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../controller/ControlCenterLayoutController';
import { AddMoreToggleButton } from './AddMoreToggleButton';
import Constants, {
  HEADER_BUTTON_TRANSLATE_COMPACT,
  TOGGLE_SPACE_COMPACT,
  TOGGLE_EDIT_HEAD_ZINDEX,
  TOGGLE_LIBRARY_HEAD_ZINDEX,
  TOGGLE_EDIT_LIBRARY_HEIGHT
} from '../common/Constants';
import { AccessibilityUtilExt } from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityUtilExt';
import { AccessibilityVm } from '@ohos/systemuicommon/src/main/ets/vm/AccessibilityVm';
import { LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/src/main/ets/template/newStyle/BrightnessOptionUtils';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ScrollBlurController } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurController';
import { ScrollBlurViewData } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurViewData';
import { StorageAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/StorageAdapter';
import { curves } from '@kit.ArkUI';
import { HeaderViewModel } from '../viewModel/HeaderViewModel';
import { KeyCode } from '@kit.InputKit';
import TopToggleLoader from '../pages/newStyle/TopToggleLoader';
import { TopToggleEditViewModel } from '../vm/TopToggleEditViewModel';
import { QuickToggleEditViewModel } from '../vm/QuickToggleEditViewModel';
import { IotEditViewModel } from '../vm/IotEditViewModel';

const TAG = 'Ctrl.ToggleEditView';
const LEFT_BTN_ID: string = 'header_btn_left';
const RIGHT_BTN_ID: string = 'header_btn_right';
const DEFAULT_IOT_HEIGHT: number = 150;
const DEFAULT_BLANK_HEIGHT: number = 20;
const EDIT_PREVIEW_PANEL_MIN_HEIGHT: number = 100;
const EDIT_TOP_PREVIEW_PANEL_MIN_HEIGHT: number = 100;
const COMPONENT_ID_OPEN_CANDIDATE_LIBRARY = TAG + '_Open_Candidate_Library';
const COMPONENT_ID_CLOSE_CANDIDATE_LIBRARY = TAG + '_Close_Candidate_Library';
const COMPONENT_ID_REMOVE_BTN_IMAGE = TAG + '_Remove_Btn_Image';
const COMPONENT_ID_ADD_BTN_IMAGE = TAG + '_Add_Btn_Image';
const COMPONENT_ID_REMOVE_BTN = TAG + '_Remove_Btn';
const COMPONENT_ID_ADD_BTN = TAG + '_Add_Btn';
const COMPONENT_ID_DRAG_BAR = TAG + '_Drag_Bar';
const COMPONENT_ID_OPEN_CANDIDATE_LIBRARY_BTN = TAG + '_Open_Candidate_Library_Btn';
const TOGGLE_PREVIEW_OPACITY: number = 0.5;
const TOGGLE_SPACE: number = 16;
const HEADER_BUTTON_TRANSLATE: number = 20;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const GRID_BTN_MARGIN: number = 10;
const EDIT_BLUR_EREA: number = 111;
const EDIT_NARROW_WIDTH: number = 324;
const EDIT_DEFAULT_WIDTH: number = 336;

@Component
export struct ToggleEditView {
  // 参数
  @Link screenWidth: number;
  private pageWidth: number = 672;
  private editHeadAreaHeight: number = 116;
  @State iotHeight: number = DEFAULT_IOT_HEIGHT;
  @BuilderParam toggleLoader: (slot: string, isDragging: boolean) => void;
  @State previewToggles: string[] = [];
  @State libraryToggles: string[] = [];
  @State previewTopToggles: string[] = [];
  @State libraryTopToggles: string[] = [];
  @Link @Watch('onEditModeChange') isEditMode: boolean;
  private isIotEditSupported: boolean = Constants.IS_IOT_EDIT_SUPPORTED;
  private showToast?: (msg: ResourceStr) => void;
  // 以下为内部变量
  @State viewData: ToggleEditViewData = new ToggleEditViewData();
  @State toggleScales: Map<string, number> = new Map();
  @State toggleOpacities: Map<string, number> = new Map();
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  @StorageLink('currentDragSlotItem') currentDragSlotItem: string = '';
  @StorageLink('controlCenterFontScale') controlCenterFontScale: number = 1;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  private showDoubleColumn: boolean = CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.isEditPageDoubleColumn ?? false;
  private doubleColumnGap: number = CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.editPageDoubleColumnGap ?? 0;
  private columnSpace: number = ResUtils.getNumber($r('app.float.control_center_edit_page_column_space'));
  private portraitWidth = ResUtils.getNumber($r('app.float.Control_center_portrait_width'));
  private viewModel: ToggleEditViewModel =
    new ToggleEditViewModel(this.viewData, this.showDoubleColumn);
  private topToggleViewModel: TopToggleEditViewModel =
    new TopToggleEditViewModel(this.viewData, this.showDoubleColumn);
  private quickToggleViewModel: QuickToggleEditViewModel =
    new QuickToggleEditViewModel(this.viewData, this.showDoubleColumn);
  private iotViewModel: IotEditViewModel =
    new IotEditViewModel(this.viewData, this.showDoubleColumn);

  private colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private saveConfirmController?: CustomDialogController = new CustomDialogController({
    builder: AlertDialog({
      content: $r('app.string.control_center_edit_panel_dialog_confirm'),
      primaryButton: {
        value: $r('app.string.control_center_edit_panel_dialog_not_save'),
        action: this.viewModel.onCancelOptionClicked,
      },
      secondaryButton: {
        value: $r('app.string.control_center_edit_panel_dialog_save'),
        action: this.viewModel.onSaveOptionClicked,
      },
    }),
    alignment: DialogAlignment.Center,
    autoCancel: true,
    cancel: this.viewModel.onConfirmDialogCanceled,
  });
  private blurArea: RectInfo = new RectInfo();
  private scrollBlurController?: ScrollBlurController;
  private editPageWidth: number = ResUtils.getNumber($r('app.float.control_center_edit_page_width'));
  private headerWidth: number = ResUtils.getNumber($r('app.float.control_center_edit_page_width'));
  @State scrollBlurViewData: ScrollBlurViewData = new ScrollBlurViewData();
  private isTouchingScroll: boolean = false;
  private filter: uiEffect.Filter = uiEffect.createFilter();

  @Styles normalStyle() {
    .border(undefined)
  }

  @Styles focusedStyle() {
    .borderRadius(16)
    .borderWidth(2)
    .borderColor(this.colorModeViewData.commonBgOnColor)
    .width(32)
    .height(32)
    .offset({ x: -6, y: 5.8 })
  }

  aboutToAppear() {
    this.initEditStyle();
    // 预构建阶段只准备预览完成态；待添加库延后加载，避免进入编辑卡顿
    this.viewData.previewToggleScale = 1;
    this.viewData.borderScale = 1;
    this.viewData.toggleSubscriptScale = 1;
    this.viewData.toggleSubscriptOpacity = 1;
    this.viewData.borderColor = '#99ffffff';
    this.viewModel.previewToggles = this.previewToggles;
    this.viewModel.libraryToggles = this.libraryToggles;
    this.viewModel.previewTopToggles = this.previewTopToggles;
    this.viewModel.libraryTopToggles = this.libraryTopToggles;
    this.viewData.iotPageHeight = this.iotHeight === 0 ? DEFAULT_IOT_HEIGHT : this.iotHeight;
    this.viewModel.showToast = this.showToast;
    this.viewModel.saveConfirmController = this.saveConfirmController;
    this.scrollBlurController = new ScrollBlurController(this.viewModel.scroller, 113);
    this.viewModel.scrollBlurController = this.scrollBlurController;
    this.viewModel.initTopToggleViewModel(this.topToggleViewModel)
    this.viewModel.initQuickToggleViewModel(this.quickToggleViewModel);
    this.viewModel.initIotViewModel(this.iotViewModel);
    this.viewModel.onViewAppear();
    this.blurArea.left = 0;
    this.blurArea.top = 0;
    this.blurArea.height = 111;
    this.blurArea.width = this.screenWidth;
    this.scrollBlurController?.init(this.blurArea, this.scrollBlurViewData);
    if (this.editPageWidth === 0) {
      log.showInfo('occurred when obtaining the width of the editing page is fail');
      this.editPageWidth = EDIT_DEFAULT_WIDTH
    };
    if (this.headerWidth === 0) {
      log.showInfo('occurred when obtaining the width of the editing page header is fail');
      this.headerWidth = EDIT_DEFAULT_WIDTH
    }
  }

  aboutToDisappear() {
    this.viewModel.onViewDisappear();
    this.scrollBlurController?.unregister();
    this.saveConfirmController = undefined;
  }

  private buttonClickEffect(event: TouchEvent, isLeft: boolean) {
    if (event.type === TouchType.Down) {
      animateTo({
        curve: curves.springMotion(0.31, 0.94)
      }, () => {
        if (isLeft) {
          this.viewData.leftBtnScale = 0.9;
        } else {
          this.viewData.rightBtnScale = 0.9;
        }
      });
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      animateTo({
        curve: curves.springMotion(0.31, 0.94)
      }, () => {
        if (isLeft) {
          this.viewData.leftBtnScale = 1;
        } else {
          this.viewData.rightBtnScale = 1;
        }
      });
    }
  }

  private initEditStyle() {
    if (this.showDoubleColumn && this.ccLayoutIndex === ControlCenterLayoutIndex.FOLD_EXPANDED) {
      this.headerWidth = ResUtils.getNumber($r('app.float.Large_fold_control_center_edit_page_header_width'));
    }
  }

  build() {
    if (this.showDoubleColumn) {
      this.buildDoubleColumnEditView()
    } else {
      this.buildSingleColumnEditView()
    }
  }

  @Builder
  buildSingleColumnEditView() {
    Stack() {
      // 预览页
      this.buildPreviewPage();
      // 备选库，延迟到完全进入编辑页后加载
      if (this.viewData.loadToggleLibrary) {
        Stack().parentSize()
          .onClick(() => {
            this.viewModel.setCollapseLibraryReason(CollapseLibraryType.CLICK_BLANK);
            this.viewModel.onBackButtonClicked();
          })
          .visibility(this.isShowingLibrary() ? Visibility.Visible : Visibility.None)
          .focusable(false)
          .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
        this.buildBottomLibrary(ToggleEditType.TOP_TOGGLE);
        this.buildBottomLibrary(ToggleEditType.QUICK_TOGGLE);
        if (this.viewData.loadIotLibrary) {
          this.buildBottomLibrary(ToggleEditType.IOT);
        }
      }
    }
    .parentSize()
    .hitTestBehavior(this.viewData.enterEditFinished ? HitTestMode.Default : HitTestMode.Block)
    .alignContent(Alignment.Bottom)
  }

  @Builder
  buildDoubleColumnEditView() {
    Stack() {
      this.buildHeader(this.headerWidth);
      Row() {
        // 备选库
        this.buildSideLibrary()
        Blank()
        // 预览页
        this.buildSidePreviewPage();
      }
      .direction(this.ccLayoutIndex === ControlCenterLayoutIndex.FOLD_EXPANDED ? Direction.Auto : Direction.Ltr)
      .layoutWeight(1)
      .width('100%')
      .constraintSize({ maxWidth: this.pageWidth + this.doubleColumnGap, minWidth: this.pageWidth })
      .clip(!this.scrollBlurController?.getScrollBlurEnableState() ?
        new Rect({
          width: this.blurArea.width,
          height: '100%'
        }).position({ y: this.blurArea.height }) : false
      )
      if (this.scrollBlurViewData.getBlurActive()) {
        Column()
          .height(this.blurArea.height)
          .width(this.blurArea.width)
          .compositingFilter(this.scrollBlurController?.getBlurCompositingFilter(this.filter))
          .offset(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.foldEditHeadOffset)
      }
    }
    .direction(Direction.Ltr)
    .alignContent(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelAlignment)
    .parentSize()
    // 横竖屏切换时刷新
    .padding(this.screenWidth && CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.editPagePadding)
    .hitTestBehavior(this.viewData.enterEditFinished ? HitTestMode.Default : HitTestMode.Block)
    .onClick(this.isShowingLibrary() ? () => {
      this.viewModel.setCollapseLibraryReason(CollapseLibraryType.CLICK_BLANK);
      this.viewModel.onBackButtonClicked();
    } : undefined)
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
  }

  @Builder
  buildSideLibrary() {
    Stack() {
      if (this.viewData.showQuickToggleLibrary) {
        this.buildSideLibraryPage(ToggleEditType.QUICK_TOGGLE);
        if (this.libraryToggles.length === 0) {
          this.buildNoAvailableTogglesHint();
        }
      } else if (this.viewData.showTopToggleLibrary) {
        this.buildSideLibraryPage(ToggleEditType.TOP_TOGGLE);
        if (this.libraryTopToggles.length === 0) {
          this.buildNoAvailableTogglesHint();
        }
      } else if (this.viewData.loadIotLibrary) {
        this.buildSideLibraryPage(ToggleEditType.IOT);
      }
    }
    .width(this.editPageWidth)
    .height(`calc(100% - ${this.editHeadAreaHeight}vp)`)
    .alignContent(Alignment.Top)
    .padding({ bottom: 44, top: 3 })
    .margin({top: this.editHeadAreaHeight})
    .zIndex(1)
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
  }

  @Builder
  buildPreviewPage() {
    Stack() {
      this.buildHeader(this.headerWidth)

      Scroll(this.viewModel.scroller) {
        Column() {
          this.buildTopToggleEditPreview()
          this.buildQuickToggleEditPreview()
          this.buildIotEditPreview()
          Blank().height(DEFAULT_BLANK_HEIGHT)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .height(this.viewData.showIotLibrary || this.viewData.showQuickToggleLibrary ||
          this.viewData.showTopToggleLibrary ? 10000 : undefined)
        .margin({
          top: this.editHeadAreaHeight,
          bottom: (this.viewData.showQuickToggleLibrary || this.viewData.showTopToggleLibrary) ? 406 : 0
        })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
      .align(Alignment.Top)
      .clip(!this.scrollBlurController?.getScrollBlurEnableState() ?
        new Rect({
          width: this.blurArea.width,
          height: '100%'
        }).position({ y: this.blurArea.height }) : false
      )
      .onScrollStart(this.viewModel.onScrollStart)
      .onScrollStop(this.viewModel.onScrollStop)
      .enableScrollInteraction(!this.viewData.showIotLibrary && this.viewData.enterEditFinished)
      .onSizeChange(this.viewModel.onScrollSizeChange)
      .edgeEffect(EdgeEffect.Spring)
      .onScrollFrameBegin((yOffset: number) => {
        this.isTouchingScroll = true;
        this.scrollBlurController?.onScrollWithBlur();
        return { offsetRemain: this.iotViewModel.dragIotCard ? 0 : yOffset };
      })
      .onDidScroll(() => {
        if (!this.isTouchingScroll) {
          this.scrollBlurController?.onListScrollWithBlurAnimate();
        }
        this.isTouchingScroll = false;
      })
      if (this.scrollBlurViewData.getBlurActive()) {
        Column()
          .height(this.blurArea.height)
          .width(this.blurArea.width)
          .compositingFilter(this.scrollBlurController?.getBlurCompositingFilter(this.filter))
      }
    }
    .alignContent(Alignment.Top)
    .parentSize()
    .accessibilityLevel(this.isShowingLibrary() ? 'no-hide-descendants' : 'auto')
  }

  @Builder
  buildSidePreviewPage() {
    Scroll(this.viewModel.scroller) {
      Column() {
        this.buildTopToggleEditPreview()
        this.buildQuickToggleEditPreview()
        this.buildIotEditPreview()
        Blank().height(DEFAULT_BLANK_HEIGHT)
      }
      .margin({top: this.editHeadAreaHeight})
      .width('100%')
      // scroll占位，使iot卡片可以滚动到顶部
      .height(this.viewData.showIotLibrary || this.viewData.showQuickToggleLibrary ||
        this.viewData.showTopToggleLibrary ? 10000 : undefined)
      .alignItems(HorizontalAlign.Center)
    }
    .height('100%')
    .id('side_preview_page')
    // 避免子组件边框被裁切，this.editPageWidth+32+32=400
    .width(400)
    .margin({ left: -32, right: -32 })
    .scrollBar(BarState.Off)
    .align(Alignment.Top)
    .clip(this.viewData.enterEditFinished)
    .onScrollStart(this.viewModel.onScrollStart)
    .onScrollStop(this.viewModel.onScrollStop)
    .enableScrollInteraction(!this.isShowingLibrary())
    .onSizeChange(this.viewModel.onScrollSizeChange)
    .hitTestBehavior(this.isShowingLibrary() ? HitTestMode.Block : HitTestMode.Default)
    .onClick(this.isShowingLibrary() ? () => {
      this.viewModel.setCollapseLibraryReason(CollapseLibraryType.CLICK_BLANK);
      this.viewModel.onBackButtonClicked();
      } : undefined)
    .edgeEffect(EdgeEffect.Spring)
    .onScrollFrameBegin((offset: number) => {
      this.scrollBlurController?.onScrollWithBlur();
      return { offsetRemain: this.iotViewModel.dragIotCard ? 0 : offset };
    })
    .onDidScroll(() => {
      if (!this.isTouchingScroll) {
        this.scrollBlurController?.onListScrollWithBlurAnimate();
      }
      this.isTouchingScroll = false;
    })
    .accessibilityLevel(this.isShowingLibrary() ? 'no-hide-descendants' : 'auto')
    .focusable(!this.isShowingLibrary())
  }

  @Builder
  buildSideLibraryPage(toggleEditType: ToggleEditType) {
    Column() {
      if (toggleEditType === ToggleEditType.IOT) {
        this.buildLibaryPanels(ToggleEditType.IOT)
      } else {
        Column() {
          this.buildLibaryPanels(toggleEditType)
        }
        // 侧边备选库可以滚动时，顶部保留一定空间使开关过界截断效果显示自然
        .padding({top: 6, bottom: 16, left: 16, right: 16})
        .margin({top: 10, bottom: 16})
        .clip(true)
      }

      Text($r('app.string.control_center_edit_panel_collapse_library'))
        .width(304)
        .height(48)
        .lineHeight(21 * this.controlCenterFontScale + 'vp')
        .fontColor($r('app.color.control_center_edit_collapse_library_button_text_color'))
        .textAlign(TextAlign.Center)
        .font({
          family: 'HarmonyHeiTi',
          weight: FontWeight.Medium,
          size: 16 * this.controlCenterFontScale + 'vp',
        })
        .borderRadius(24)
        .backgroundColor($r('app.color.control_center_edit_collapse_library_button_bg_color'))
        .backgroundBrightnessInternal(this.colorModeViewData.isBrightnessActive ? BrightnessOptionUtils
          .getInstance().backgroundFiveOption : undefined)
        .onClick(() => {
          this.viewModel.setCollapseLibraryReason(CollapseLibraryType.CLICK_COLLAPSE_LIB);
          this.viewModel.onBackButtonClicked();
          this.uiContextRequestFocus(COMPONENT_ID_OPEN_CANDIDATE_LIBRARY_BTN);
        })
        .accessibilityText(ResUtils.getInnerString($r('app.string.cc_accessibility_str_collapse_library')))
        .accessibilityRole(AccessibilityRoleType.BUTTON)
        .opacity(0.6)
        .scale({ x: this.viewData.collapseBtnScale, y: this.viewData.collapseBtnScale })
        .onHover((isHover?: boolean) => this.viewModel.handleOnHover(ToggleButtonType.COLLAPSE_BUTTON, isHover))
    }
    .parentSize()
    .borderRadius(32)
    .padding(toggleEditType === ToggleEditType.IOT ? 16 : {bottom: 16})
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.control_center_edit_collapse_library_button_bg_color'))
    .backgroundBrightnessInternal(this.colorModeViewData.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .backgroundEightOption : undefined)
    .visibility(toggleEditType === ToggleEditType.IOT ?
      (this.viewData.showIotLibrary ? Visibility.Visible : Visibility.Hidden) : Visibility.Visible)
    .transition(TransitionEffect.scale({ x: 0.9, y: 0.9 }).combine(TransitionEffect.OPACITY))
    .onClick(() => {
      // 空实现，避免触发父组件点击收起备选库事件
    })
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
    .id(COMPONENT_ID_CLOSE_CANDIDATE_LIBRARY)
  }

  @Builder
  buildLibaryPanels(toggleEditType:ToggleEditType) {
    if (toggleEditType === ToggleEditType.IOT) {
      this.buildIotLibrary();
    } else if (toggleEditType === ToggleEditType.QUICK_TOGGLE) {
      this.buildTogglesGrid(false, false)
      Blank()
    } else if (toggleEditType === ToggleEditType.TOP_TOGGLE) {
      this.buildTopTogglesGrid(false)
      Blank()
    }
  }

  @Builder
  buildHeader(width: Length = '100%') {
    if (this.viewData.showEditHeader) {
      Row() {
        this.buildHeaderButton($r(HeaderViewModel.getInstance().getIconName('chevron_backward', 'ic_back_edit')),
          LEFT_BTN_ID, this.viewModel.onBackButtonClicked)
        Text($r('app.string.control_center_edit_panel_title_edit'))
          .font({ size: 20 * this.controlCenterFontScale + 'vp', family: 'HarmonyHeiTi', weight: 'SemiBold' })
          .fontColor($r('app.color.center_edit_page_header_text_color'))
          .margin({ left: 12, right: 12 })
          .geometryTransition('edit_text')
          .accessibilityLevel('auto')
        Blank()
        this.buildHeaderButton($r(HeaderViewModel.getInstance().getIconName('checkmark', 'ic_public_ok_filled_edit')),
          RIGHT_BTN_ID, this.viewModel.onSaveButtonClicked)
      }
      .width(width)
      .height(40)
      .opacity(this.isShowingLibrary() ? TOGGLE_PREVIEW_OPACITY : 1)
      .padding({ left: 16, right: 16 })
      .margin({ top: 56, bottom: 20 })
      .alignItems(VerticalAlign.Center)
      .transition(TransitionEffect.opacity(0.99)
        .combine(TransitionEffect.translate({y: HEADER_BUTTON_TRANSLATE}))
        .animation({curve: curves.springMotion(0.31, 0.6)}))
      .accessibilityLevel(this.isShowingLibrary() ? 'no-hide-descendants' : 'auto')
      .zIndex(TOGGLE_EDIT_HEAD_ZINDEX)
    } else {
      Row() {
        this.buildHeaderButton($r(HeaderViewModel.getInstance().getIconName('square_and_pencil', 'ic_public_edit')),
          LEFT_BTN_ID, this.viewModel.onBackButtonClicked)
        Text($r('app.string.control_center_edit_panel_title_edit'))
          .font({ size: 20 * this.controlCenterFontScale + 'vp', family: 'HarmonyHeiTi', weight: 'SemiBold' })
          .fontColor($r('app.color.center_main_page_header_text_color'))
          .margin({ left: 12, right: 12 })
          .geometryTransition('edit_text')
        Blank()
        this.buildHeaderButton($r(HeaderViewModel.getInstance().getIconName('gearshape', 'ic_public_settings')),
          RIGHT_BTN_ID, this.viewModel.onSaveButtonClicked)
      }
      .width(width)
      .height(40)
      .padding({ left: 16, right: 16 })
      .margin({ top: 56, bottom: 20 })
      .translate({ y: 20 })
      .alignItems(VerticalAlign.Center)
    }
  }

  @Builder
  buildTopToggleEditPreview() {
    Stack() {
      Stack()
        .width(this.isNarrowScreen() ? EDIT_NARROW_WIDTH : this.editPageWidth)
        .height('100%')
        .borderRadius(this.isNarrowScreen() ? 30 : 32)
        .outline({
          width: 3,
          radius: this.isNarrowScreen() ? 33 : 35,
          color: this.showDoubleColumn && this.viewData.showTopToggleLibrary ? '#00ffffff' : this.viewData.borderColor
        })
        .scale({ x: this.viewData.borderScale, y: this.viewData.borderScale })
      Column() {
        Column({ space: 16 }) {
          if (this.previewTopToggles.length > 0) {
            this.buildTopTogglesGrid(true)
          }
          if (!this.viewData.showTopToggleLibrary) {
            this.buildAddButton(() => this.topToggleViewModel.onAddButtonClicked())
          }
        }
        .parentSize()
        .padding(16)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .clip(true)
        .border({ radius: 32 })
        .width(this.editPageWidth)
      }
      .clip(true)
      .width(this.isNarrowScreen() ? EDIT_NARROW_WIDTH : this.editPageWidth)
    }
    .width(this.editPageWidth)
    .height(this.viewData.editTopPreviewPanelHeight < EDIT_TOP_PREVIEW_PANEL_MIN_HEIGHT ?
      EDIT_TOP_PREVIEW_PANEL_MIN_HEIGHT : this.viewData.editTopPreviewPanelHeight)
    .opacity(this.isShowingLibrary() ?
      (this.viewData.showQuickToggleLibrary ? 0 : TOGGLE_PREVIEW_OPACITY) : 1)
  }

  @Builder
  buildTopTogglesGrid(inPreview: boolean) {
    if (inPreview) {
      this.topToggleGridLayout(true)
    } else {
      // 与快捷栏待添加区一致：固定可视高度内滚动
      Scroll() {
        this.topToggleGridLayout(false)
      }
      .align(Alignment.Top)
      .clip(false)
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .height(this.showDoubleColumn ? this.getTopTogglePanelHeight() : 334)
    }
  }

  @Builder
  topToggleGridLayout(inPreview: boolean) {
    Grid(undefined, this.topToggleViewModel.topGridLayoutOptions(inPreview)) {
      ForEach(inPreview ? this.previewTopToggles : this.libraryTopToggles, (item: string, index: number) => {
        if (inPreview) {
          this.buildTopGridItemPreview(item, index)
        } else {
          this.buildTopToggleLibraryItem(item)
        }
      }, (item: string, index?: number) => item)
    }
    .margin(inPreview ? undefined : { bottom: this.columnSpace })
    .height(this.getTopToggleGridHeight(inPreview))
    .constraintSize({ minHeight: 16 })
    .width('100%')
    .columnsGap(this.columnSpace)
    .rowsGap(TOGGLE_SPACE)
    .clip(false)
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .rowsTemplate(Array(this.topToggleViewModel.getToggleRows(inPreview ? this.previewTopToggles :
    this.libraryTopToggles)).fill('1fr').join(' '))
  }

  @Builder
  buildTopGridItemPreview(item: string, idx: number) {
    GridItem() {
      Stack() {
        TopToggleLoader({ toggleSlot: item, isEditMode: true, enableGeometryTransition: false })
        // 右上角角标（与快捷栏一致）
        Image($r('app.media.ic_remove')).size({ width: 26, height: 26 })
          .margin({ top: -6, right: -6 })
          .borderRadius(26)
          .scale({ x: this.viewData.toggleSubscriptScale, y: this.viewData.toggleSubscriptScale })
          .opacity(this.viewData.toggleSubscriptOpacity)
          .visibility((item === this.viewData.dragItem || this.viewData.showTopToggleLibrary) ? Visibility.Hidden :
          Visibility.Visible)
          .id(COMPONENT_ID_REMOVE_BTN_IMAGE)
        // 用于屏蔽快捷开关的点击、拖动等事件
        Stack().parentSize().visibility(item === this.viewData.dragItem ? Visibility.Hidden : Visibility.Visible).accessibilityLevel('no')
        Stack().size({ width: 44, height: 44 })
          .margin({ top: -15, right: -15 })
          .onClick(() => {
            this.topToggleViewModel.onToggleClicked(item, true, idx);
            this.uiContextRequestFocus(COMPONENT_ID_REMOVE_BTN + '_top')
          })
          .visibility(item === this.viewData.dragItem ? Visibility.Hidden : Visibility.Visible)
          .id(COMPONENT_ID_REMOVE_BTN + ToggleEditType.TOP_TOGGLE)
          .accessibilityLevel(this.isAccessibilityMode ? 'yes' : 'auto')
          .accessibilityRole(AccessibilityRoleType.BUTTON)
          .accessibilityText(this.topToggleViewModel.getEditToggleActionText(item))
          .accessibilityDescription(ResUtils.getInnerString($r('app.string.cc_accessibility_str_click')) +
          ResUtils.getInnerString($r('app.string.cc_accessibility_str_edit_drag_description')))
          .stateStyles({
            focused: this.focusedStyle,
            normal: this.normalStyle
          })
      }
      .focusable(!this.isShowingLibrary())
      .height(this.topToggleViewModel.isCombinedToggle(item) ?
        $r('app.float.Control_center_meidaCard_width') :
      $r('app.float.Control_center_long_button_height'))
      .width(this.topToggleViewModel.isCombinedToggle(item) ?
        $r('app.float.Control_center_meidaCard_width') : undefined)
      .alignContent(Alignment.TopEnd)
      .scale({ x: item === this.viewData.dragItem ? 1.08 : 1, y: item === this.viewData.dragItem ? 1.08 : 1 })
      .translate(item === this.viewData.dragItem ? { x: this.viewData.offsetX, y: this.viewData.offsetY }
        : { x: 0, y: 0 })
      .gesture(
        GestureGroup(GestureMode.Sequence,
          LongPressGesture({ fingers: 1, repeat: false, duration: 300 })
            .onAction(() => {
              this.currentDragSlotItem = item;
              this.topToggleViewModel.onLongPressActionForDrag(item)
            })
            .onActionCancel(() => {
              this.currentDragSlotItem = '';
              this.topToggleViewModel.onActionEndForDrag()
            })
            .onActionEnd(() => {
              this.currentDragSlotItem = '';
              this.topToggleViewModel.onLongPressActionEndForDrag()
            }),
          PanGesture({ fingers: 1, distance: 0 })
            .onActionStart(() => {
              this.topToggleViewModel.onActionStartForDrag(item)
            })
            .onActionUpdate((event) => {
              if (item !== this.viewData.dragItem) {
                return;
              }
              this.topToggleViewModel.onActionUpdateForDrag(event)
            })
            .onActionCancel(() => {
              this.currentDragSlotItem = '';
              this.topToggleViewModel.onActionEndForDrag()
            })
            .onActionEnd(() => {
              this.currentDragSlotItem = '';
              this.topToggleViewModel.onActionEndForDrag()
            }))
          .onCancel(() => {
            this.currentDragSlotItem = '';
            this.topToggleViewModel.onActionEndForDrag()
          })
      )
      .accessibilityLevel(this.isAccessibilityMode ? 'yes' : 'auto')
      .accessibilityRole(AccessibilityRoleType.BUTTON)
      .accessibilityText(this.topToggleViewModel.getEditToggleText(item))
      .accessibilityDescription(ResUtils.getInnerString($r('app.string.cc_accessibility_str_edit_drag_description')))
    }
    .onKeyPreIme((event: KeyEvent) => {
      return false
    })
    .zIndex(item === this.viewData.dragItem ? 1 : 0)
    .scale({ x: this.viewData.previewToggleScale, y: this.viewData.previewToggleScale })
    // 仅编辑过程中做出入场动效
    .transition((!this.viewData.loadToggleLibrary || item === this.viewData.dragItem) ? undefined
      : TransitionEffect.scale({ x: 0.8, y: 0.8 })
      .combine(TransitionEffect.OPACITY)
      .animation({ duration: 250, curve: Curve.Friction }))
  }


  @Builder
  buildQuickToggleEditPreview() {
    Stack() {
      Stack()
        .width(this.isNarrowScreen() ? EDIT_NARROW_WIDTH : this.editPageWidth)
        .height('100%')
        .borderRadius(this.isNarrowScreen() ? 30 : 32)
        .outline({
          width: 3,
          radius: this.isNarrowScreen() ? 33 : 35,
          color: this.showDoubleColumn && this.viewData.showQuickToggleLibrary ? '#00ffffff' : this.viewData.borderColor
        })
        .scale({ x: this.viewData.borderScale, y: this.viewData.borderScale })
      Column() {
        Column() {
          if (this.previewToggles?.length > 0) {
            this.buildTogglesGrid(true)
          }
          if (!this.viewData.showQuickToggleLibrary) {
            this.buildAddButton(() => this.quickToggleViewModel.onAddButtonClicked())
          }
        }
        .parentSize()
        .padding(16)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)
        .clip(true)
        .border({ radius: 32 })
        .width(this.editPageWidth)
      }
      .clip(true)
      .width(this.isNarrowScreen() ? EDIT_NARROW_WIDTH : this.editPageWidth)
    }
    .width(this.editPageWidth)
    .height(this.viewData.editPreviewPanelHeight < EDIT_PREVIEW_PANEL_MIN_HEIGHT ?
      EDIT_PREVIEW_PANEL_MIN_HEIGHT : this.viewData.editPreviewPanelHeight)
    .opacity(this.isShowingLibrary() ? (this.viewData.showTopToggleLibrary ? 0 : TOGGLE_PREVIEW_OPACITY) : 1)
    .margin({ top: 14 })
  }

  @Builder
  buildIotEditPreview() {
    if (this.isIotEditSupported) {
      Row() {
        UIExtensionComponent({
          bundleName: 'com.ohos.ailifesvc',
          abilityName: 'IotDeviceEditAbility',
          parameters: { 'ability.want.params.uiExtensionType': 'sys/commonUI' }
        },
          { dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI })
          .width('100%')
          .height(this.viewData.iotPageHeight)
          .onRemoteReady(this.iotViewModel.onIotRemoteReady)
          .onReceive(this.iotViewModel.onIotMessage)
          .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT)
      }
      .visibility(this.viewData.showQuickToggleLibrary || this.viewData.showTopToggleLibrary ? Visibility.None :
      Visibility.Visible)
    }
  }

  @Builder
  buildBottomLibrary(toggleEditType: ToggleEditType) {
    Stack() {
      // 模糊背板
      Stack() {
      }
      .parentSize()
      .borderRadius({ topLeft: 32, topRight: 32 })
      .backgroundColor(DevHelper.getStrParam('cc.edit.library.backgroundColor', '#26ffffff'))
      .backgroundEffect({
        policy: 1,
        radius: DevHelper.getNumParam('cc.edit.library.backgroundEffect.radius', 150),
        saturation: DevHelper.getNumParam('cc.edit.library.backgroundEffect.saturation', 0.9),
        brightness: DevHelper.getNumParam('cc.edit.library.backgroundEffect.brightness', 1.1),
      }, { disableSystemAdaptation: true })
      .opacity(0.75)
      .shadow({
        offsetY: 10,
        offsetX: 0,
        type: ShadowType.COLOR,
        color: '#66000000',
        radius: 60,
      })

      // 备选库开关
      if (toggleEditType === ToggleEditType.IOT) {
        this.buildIotLibrary()
      } else if (toggleEditType === ToggleEditType.QUICK_TOGGLE) {
        this.buildQuickTogglesLibrary()
      } else if (toggleEditType === ToggleEditType.TOP_TOGGLE) {
        this.buildTopTogglesLibrary()
      }

      // drag bar
      if (this.isAccessibilityMode) {
        Column() {
          this.loadDragBar(toggleEditType);
        }
        .onClick(() => {
          this.viewModel.setCollapseLibraryReason(CollapseLibraryType.CLICK_SLIDE_BAR);
          this.viewModel.onBackButtonClicked();
        })
        .accessibilityText(ResUtils.getInnerString($r('app.string.cc_accessibility_str_collapse_library')))
        .accessibilityRole(AccessibilityRoleType.BUTTON)
      } else {
        this.loadDragBar(toggleEditType);
      }
    }
    .width('100%')
    .height(TOGGLE_EDIT_LIBRARY_HEIGHT)
    .visibility(toggleEditType === ToggleEditType.IOT ?
      (this.viewData.showIotLibrary ? Visibility.Visible : Visibility.Hidden) : Visibility.Visible)
    .translate(this.libraryPanelTranslate(toggleEditType))
    .align(Alignment.Top)
  }

  private libraryPanelTranslate(toggleEditType: ToggleEditType): TranslateOptions {
    if (toggleEditType === ToggleEditType.IOT) {
      return { x: 0, y: this.viewData.iotLibraryTrans };
    } else if (toggleEditType === ToggleEditType.QUICK_TOGGLE) {
      return { x: 0, y: this.viewData.quickLibraryTrans };
    } else if (toggleEditType === ToggleEditType.TOP_TOGGLE) {
      return { x: 0, y: this.viewData.topLibraryTrans };
    }
    return { x: 0, y: 0 }
  }

  @Builder
  loadDragBar(toggleEditType: ToggleEditType) {
    Stack() {
      Image($r('app.media.bt_bottomsheet_handle_normal'))
        .height(16)
        .width(64)
        .margin({ top: 4 })
        .draggable(false)
        .onClick(() => {
          this.viewModel.setCollapseLibraryReason(CollapseLibraryType.CLICK_SLIDE_BAR);
          this.viewModel.onBackButtonClicked();
          this.uiContextRequestFocus(COMPONENT_ID_OPEN_CANDIDATE_LIBRARY_BTN)
        })
        .onKeyPreIme((event: KeyEvent) => {
          return this.viewModel.onKeyPreForbidAction(event, KeyCode.KEYCODE_DPAD_RIGHT)
        })
        .focusable(this.isShowingLibrary())
        .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
        .zIndex(TOGGLE_LIBRARY_HEAD_ZINDEX)
        .id(COMPONENT_ID_DRAG_BAR + toggleEditType)
    }
    .align(Alignment.Top)
    .height(30)
    .width('100%')
    .gesture(PanGesture({ direction: PanDirection.Down, distance: 1 })
      .onActionStart((event: GestureEvent): void => this.viewModel.onPanActionStart(event))
      .onActionUpdate((event: GestureEvent): void => this.viewModel.onPanActionUpdate(event, toggleEditType))
      .onActionEnd((event: GestureEvent): void => this.viewModel.onPanActionEnd(event, toggleEditType))
      .onActionCancel((event: GestureEvent): void => this.viewModel.onPanActionEnd(event, toggleEditType)))
  }

  @Builder
  buildIotLibrary() {
    UIExtensionComponent({
      bundleName: 'com.ohos.ailifesvc',
      abilityName: 'IotEditDetachAbility',
      parameters: { 'ability.want.params.uiExtensionType': 'sys/commonUI' },
    },
      { dpiFollowStrategy: DpiFollowStrategy.FOLLOW_HOST_DPI })
      .width(this.editPageWidth)
      .height(this.showDoubleColumn ? undefined : '100%')
      .layoutWeight(this.showDoubleColumn ? 1 : undefined)
      .onReceive(this.iotViewModel.onIotMessage)
      .accessibilityUseSamePage(AccessibilitySamePageMode.FULL_SILENT)
  }

  @Builder
  buildTopTogglesLibrary() {
    // 备选库开关（结构与快捷栏待添加区一致）
    Stack() {
      this.buildTopTogglesGrid(false);
    }
    .clip(true)
    .padding({ top: 9.5, left: 16, right: 16 })
    .margin({ top: 30 })
    .width(this.editPageWidth)
    .height('100%')
    .alignContent(Alignment.Top)
    .direction(Direction.Ltr)

    if (this.libraryTopToggles.length === 0) {
      this.buildNoAvailableTogglesHint();
    }
  }

  @Builder
  buildQuickTogglesLibrary() {
    // 备选库开关
    Stack() {
      this.buildTogglesGrid(false, true);
    }
    .clip(true)
    .padding({ top: 9.5, left: 16, right: 16 })
    .margin({ top: 30 })
    .width(this.editPageWidth)
    .height('100%')
    .alignContent(Alignment.Top)
    .direction(Direction.Ltr)

    if (this.libraryToggles.length === 0) {
      this.buildNoAvailableTogglesHint();
    }
  }

  @Builder
  buildNoAvailableTogglesHint() {
    Column() {
      Image($r('app.media.ic_no_toggles'))
        .draggable(false)
        .size({ width: 120, height: 120 })
        .fillColor('#99000000')
      Text($r('app.string.control_center_no_available_toggles'))
        .margin({ top: 4 })
        .font({
          size: 14 * this.controlCenterFontScale + 'vp',
          family: 'HarmonyHeiTi',
          weight: 'Regular'
        })
        .fontColor('#99000000')
        .lineHeight(16 * this.controlCenterFontScale + 'vp')
    }
    .height(this.showDoubleColumn ? '80%' : undefined)
    .margin({ top: this.showDoubleColumn ? 16 : 100 })
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  buildHeaderButton(icon: Resource, id: string, onClick: (event: ClickEvent) => void) {
    Stack() {
      SymbolGlyph(icon)
        .size({ width: 24, height: 24 })
        .fontSize(Constants.ICON_FONT_SIZE + 'vp')
        .fontColor([$r('app.color.Control_center_icon_setting_color')])
        .fontWeight(FontWeight.Medium)
        .draggable(false)
        .id(`${TAG}_${id}`)
    }
    .height(40)
    .width(40)
    .align(Alignment.Center)
    .backgroundColor($r('app.color.Control_center_icon_setting_bg_color'))
    .backgroundBrightnessInternal(this.colorModeViewData.isBrightnessActive ?
      BrightnessOptionUtils.getInstance().backgroundSevenDarkOption : undefined)
    .borderRadius(40)
    .onClick(onClick)
    .onTouch((event: TouchEvent) => {
      this.buttonClickEffect(event, id === LEFT_BTN_ID);
    })
    .focusable(!this.isShowingLibrary())
    .hitTestBehavior(this.isShowingLibrary() ? HitTestMode.None : HitTestMode.Default)
    .scale({
      x: id === LEFT_BTN_ID ? this.viewData.leftBtnScale : this.viewData.rightBtnScale,
      y: id === LEFT_BTN_ID ? this.viewData.leftBtnScale : this.viewData.rightBtnScale
    })
    .onHover((isHover?: boolean) => this.viewModel.handleOnHover(
      id === LEFT_BTN_ID ? ToggleButtonType.LEFT_BUTTON : ToggleButtonType.RIGHT_BUTTON, isHover))
    .id(`${TAG}_${id}_FOCUS`)
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .accessibilityText(this.viewData.showEditHeader ? (id === 'header_btn_left' ?
      ResUtils.getInnerString($r('app.string.cc_accessibility_str_exit_edit')) :
      ResUtils.getInnerString($r('app.string.cc_accessibility_str_save_edit'))) : '' )
    .onKeyPreIme((event: KeyEvent) => {
      return id === 'header_btn_right' ? this.viewModel.onKeyPreForbidAction(event, KeyCode.KEYCODE_DPAD_RIGHT) : false
    })
  }

  @Builder
  buildAddButton(handleClick: () => void) {
    Stack() {
      AddMoreToggleButton()
        .transition(!this.viewData.enterEditFinished ? undefined : TransitionEffect.asymmetric(
          TransitionEffect.scale({ x: 0.9, y: 0.9 })
            .animation({ duration: 200, delay: 100 })
            .combine(TransitionEffect.OPACITY),
          TransitionEffect.scale({ x: 0.9, y: 0.9, centerY: 0 })
            .combine(TransitionEffect.OPACITY)
        ))
        .id(COMPONENT_ID_OPEN_CANDIDATE_LIBRARY)
        .hitTestBehavior(this.viewData.enterEditFinished ? HitTestMode.Default : HitTestMode.None)
        .scale({
          x: this.viewData.isHover ? this.viewData.addBtnScale : this.viewData.previewToggleScale,
          y: this.viewData.isHover ? this.viewData.addBtnScale : this.viewData.previewToggleScale
        })
        .onHover((isHover?: boolean) => this.viewModel.handleOnHover(ToggleButtonType.ADD_BUTTON, isHover))
    }
    .onClick(() => {
      this.getUIContext().getFocusController().clearFocus()
      handleClick();
    })
    .focusable(true)
    .accessibilityLevel(this.isAccessibilityMode ? 'yes' : 'auto')
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .accessibilityText(ResUtils.getInnerString($r('app.string.cc_accessibility_str_open_candidate_library')))
    .height(48)
    .width(this.portraitWidth)
    .borderRadius(24)
    .onKeyPreIme((event: KeyEvent) => { return this.viewModel.onKeyPreForbidAction(event, KeyCode.KEYCODE_DPAD_LEFT)})
    .id(COMPONENT_ID_OPEN_CANDIDATE_LIBRARY_BTN)
  }

  @Builder
  buildTogglesGrid(inPreview: boolean, isSemiModel?: boolean) {
    Grid() {
      ForEach(inPreview ? this.previewToggles : this.libraryToggles, (item: string, idx: number) => {
        if (inPreview) {
          this.buildQuickTogglePreviewItem(item, idx)
        } else {
          this.buildQuickToggleLibraryItem(item)
        }
      }, (item: string, idx: number) => item)
    }
    // 作为备选库使用的时候需要设置高度，使得内容超出高度范围时可滚动
    .height(this.getQuickTogglePreviewHeight(inPreview, isSemiModel))
    .scrollBar(BarState.Off)
    .width('100%')
    .constraintSize({ minHeight: 84 })
    .layoutDirection(GridDirection.Row)
    .maxCount(5)
    .columnsGap(this.columnSpace)
    .rowsGap(TOGGLE_SPACE)
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .editMode(inPreview)
    .supportAnimation(true)
    .clip(false)
    .edgeEffect(EdgeEffect.Spring)
  }

  private getQuickTogglePreviewHeight(inPreview: boolean, isSemiModel?: boolean): Length | undefined {
    if (inPreview) {
      return undefined;
    }
    if (isSemiModel) {
      return 334;
    }
    let height = ItemUtils.getRectById('side_preview_page').bottom - ItemUtils.getRectById('side_preview_page').top;
    return height - 256 - 18;
  }

  private getTopToggleGridHeight(inPreview: boolean): Length | undefined {
    return this.topToggleViewModel.getToggleGridHeight(inPreview ? this.previewTopToggles : this.libraryTopToggles);
  }

  private getTopTogglePanelHeight(): Length | undefined {
    let height = ItemUtils.getRectById('side_preview_page').bottom - ItemUtils.getRectById('side_preview_page').top;
    return height - 256 - 18;
  }

  @Builder
  buildTopToggleLibraryItem(item: string) {
    GridItem() {
      Stack() {
        TopToggleLoader({ toggleSlot: item, isEditMode: true, enableGeometryTransition: false })
        // 右上角角标（与快捷栏待添加区一致）
        Image($r('app.media.ic_add')).size({ width: 26, height: 26 })
          .margin({ top: -6, right: -6 })
          .borderRadius(26)
          .scale({ x: this.viewData.toggleSubscriptScale, y: this.viewData.toggleSubscriptScale })
          .opacity(this.viewData.toggleSubscriptOpacity)
          .visibility(item === this.viewData.dragItem ? Visibility.Hidden : Visibility.Visible)
          .id(COMPONENT_ID_ADD_BTN_IMAGE)
        // 用于屏蔽快捷开关的点击、拖动等事件
        Stack().parentSize().visibility(item === this.viewData.dragItem ? Visibility.Hidden : Visibility.Visible).accessibilityLevel('no')
        Stack().size({ width: 44, height: 44 })
          .margin({ top: -15, right: -15 })
          .onClick(() => {
            this.topToggleViewModel.onToggleClicked(item, false);
            this.uiContextRequestFocus(COMPONENT_ID_ADD_BTN + ToggleEditType.TOP_TOGGLE)
          })
          .visibility(item === this.viewData.dragItem ? Visibility.Hidden : Visibility.Visible)
          .id(COMPONENT_ID_ADD_BTN + ToggleEditType.TOP_TOGGLE)
          .accessibilityLevel(this.isAccessibilityMode ? 'yes' : 'auto')
          .accessibilityRole(AccessibilityRoleType.BUTTON)
          .accessibilityText(this.topToggleViewModel.getEditPreviewToggleText(item))
          .accessibilityDescription(ResUtils.getInnerString($r('app.string.cc_accessibility_str_click')))
          .stateStyles({
            focused: this.focusedStyle,
            normal: this.normalStyle
          })
      }
      .focusable(this.isShowingLibrary())
      .height(this.topToggleViewModel.isCombinedToggle(item) ?
        $r('app.float.Control_center_meidaCard_width') :
      $r('app.float.Control_center_long_button_height'))
      .width(this.topToggleViewModel.isCombinedToggle(item) ?
        $r('app.float.Control_center_meidaCard_width') : undefined)
      .alignContent(Alignment.TopEnd)
    }
    .onKeyPreIme((event: KeyEvent) => {
      return false
    })
    .zIndex(item === this.viewData.dragItem ? 1 : 0)
    .scale({
      x: this.toggleScales[item] ?? 1,
      y: this.toggleScales[item] ?? 1
    })
    .opacity(this.toggleOpacities[item] ?? 1)
    // 仅编辑过程中做出入场动效
    .transition(!this.viewData.loadToggleLibrary ? undefined : TransitionEffect.scale({ x: 0.8, y: 0.8 })
      .combine(TransitionEffect.OPACITY)
      .animation({ duration: 250, curve: Curve.Friction }))
  }

  @Builder
  buildQuickToggleLibraryItem(item: string) {
    GridItem() {
      Stack() {
        this.toggleLoader(item, false)
        // 右上角角标
        Image($r('app.media.ic_add'))
          .size({ width: 26, height: 26 })
          .margin({ top: -6, right: -6 })
          .scale({ x: this.viewData.toggleSubscriptScale, y: this.viewData.toggleSubscriptScale })
          .opacity(this.viewData.toggleSubscriptOpacity)
          .id(COMPONENT_ID_ADD_BTN_IMAGE)
        // 用于屏蔽快捷开关的点击、拖动等事件
        Stack().parentSize().accessibilityLevel('no')
        Stack().size({ width: 44, height: 44 })
          .margin({ top: -15, right: -15 })
          .onClick(() => {
            this.quickToggleViewModel.onToggleClicked(item, false);
            this.uiContextRequestFocus(COMPONENT_ID_ADD_BTN)
          })
          .id(COMPONENT_ID_ADD_BTN)
          .accessibilityLevel(this.isAccessibilityMode ? 'yes' : 'auto')
          .accessibilityText(AccessibilityUtilExt.getEditPreviewToggleText(item))
          .accessibilityDescription(ResUtils.getInnerString($r('app.string.cc_accessibility_str_click')))
          .stateStyles({
            focused: this.focusedStyle,
            normal: this.normalStyle
          })
      }
      .focusable(this.isShowingLibrary())
      .width(64)
      .height(84)
      .alignContent(Alignment.TopEnd)
    }
    .scale({
      x: this.toggleScales[item] ?? 1,
      y: this.toggleScales[item] ?? 1
    })
    .opacity(this.toggleOpacities[item] ?? 1)
    // 仅编辑过程中做出入场动效
    .transition(!this.viewData.loadToggleLibrary ? undefined : TransitionEffect.scale({ x: 0.8, y: 0.8 })
      .combine(TransitionEffect.OPACITY)
      .animation({ duration: 250, curve: Curve.Friction }))
    .onKeyPreIme((event: KeyEvent) => {
      return this.quickToggleViewModel.isLeftComponent(item) ?
      this.viewModel.onKeyPreForbidAction(event, KeyCode.KEYCODE_DPAD_LEFT) : false
    })
  }

  @Builder
  buildQuickTogglePreviewItem(item: string, idx: number) {
    GridItem() {
      Stack() {
        this.toggleLoader(item, false)
        // 右上角角标
        Image($r('app.media.ic_remove')).size({ width: 26, height: 26 })
          .margin({ top: -6, right: -6 })
          .scale({ x: this.viewData.toggleSubscriptScale, y: this.viewData.toggleSubscriptScale })
          .opacity(this.viewData.toggleSubscriptOpacity)
          .visibility((item === this.viewData.dragItem || this.viewData.showQuickToggleLibrary) ? Visibility.Hidden :
          Visibility.Visible)
          .id(COMPONENT_ID_REMOVE_BTN_IMAGE)
        // 用于屏蔽快捷开关的点击、拖动等事件
        Stack().parentSize().visibility(item === this.viewData.dragItem ? Visibility.Hidden : Visibility.Visible).accessibilityLevel('no')
        Stack().size({ width: 44, height: 44 })
          .margin({ top: -15, right: -15 })
          .onClick(() => {
            this.quickToggleViewModel.onToggleClicked(item, true, idx);
            this.uiContextRequestFocus(COMPONENT_ID_REMOVE_BTN)
          }).visibility(item === this.viewData.dragItem ? Visibility.Hidden : Visibility.Visible)
          .id(COMPONENT_ID_REMOVE_BTN)
          .accessibilityLevel(this.isAccessibilityMode ? 'yes' : 'auto')
          .accessibilityRole(AccessibilityRoleType.BUTTON)
          .accessibilityText(AccessibilityUtilExt.getEditToggleActionText(item))
          .accessibilityDescription(ResUtils.getInnerString($r('app.string.cc_accessibility_str_click')) +
            ResUtils.getInnerString($r('app.string.cc_accessibility_str_edit_drag_description')))
          .stateStyles({
            focused: this.focusedStyle,
            normal: this.normalStyle
          })
        // 临时方案：编辑开关顺序后，需要触发Enable属性刷新屏幕朗读缓存，保证朗读顺序和UI顺序一致
        if (this.isAccessibilityMode) {
          Column().enabled(item === this.viewData.dragItem)
        }
      }
      .focusable(!this.isShowingLibrary())
      .width(64)
      .height(84)
      .alignContent(Alignment.TopEnd)
      .scale({ x: item === this.viewData.dragItem ? 1.08 : 1, y: item === this.viewData.dragItem ? 1.08 : 1 })
      .translate(item === this.viewData.dragItem ? { x: this.viewData.offsetX, y: this.viewData.offsetY }
        : { x: 0, y: 0 })
      .gesture(
        GestureGroup(GestureMode.Sequence,
          LongPressGesture({ fingers: 1, repeat: false, duration: 300 })
            .onAction(() => {
              this.currentDragSlotItem = item;
              this.quickToggleViewModel.onLongPressActionForDrag(item)
            })
            .onActionCancel(() => {
              this.currentDragSlotItem = '';
              this.quickToggleViewModel.onActionEndForDrag()
            })
            .onActionEnd(() => {
              this.currentDragSlotItem = '';
              this.quickToggleViewModel.onLongPressActionEndForDrag()
            }),
          PanGesture({ fingers: 1, distance: 0 })
            .onActionStart(() => {
              this.quickToggleViewModel.onActionStartForDrag(item)
            })
            .onActionUpdate((event) => {
              if (item !== this.viewData.dragItem) {
                return;
              }
              this.quickToggleViewModel.onActionUpdateForDrag(event)
            })
            .onActionCancel(() => {
              this.currentDragSlotItem = '';
              this.quickToggleViewModel.onActionEndForDrag()
            })
            .onActionEnd(() => {
              this.currentDragSlotItem = '';
              this.quickToggleViewModel.onActionEndForDrag()
            }))
          .onCancel(() => {
            this.currentDragSlotItem = '';
            this.quickToggleViewModel.onActionEndForDrag()
          })
      )
      .accessibilityLevel(this.isAccessibilityMode ? 'yes' : 'auto')
      .accessibilityRole(AccessibilityRoleType.BUTTON)
      .accessibilityText(AccessibilityUtilExt.getEditToggleText(item))
      .accessibilityDescription(ResUtils.getInnerString($r('app.string.cc_accessibility_str_edit_drag_description')))
    }
    .onKeyPreIme((event: KeyEvent) => {
      return this.quickToggleViewModel.isLeftComponent(item) ?
      this.viewModel.onKeyPreForbidAction(event, KeyCode.KEYCODE_DPAD_LEFT) : false
    })
    .zIndex(item === this.viewData.dragItem ? 1 : 0)
    .scale({ x: this.viewData.previewToggleScale, y: this.viewData.previewToggleScale })
    // 仅编辑过程中做出入场动效
    .transition((!this.viewData.loadToggleLibrary || item === this.viewData.dragItem) ? undefined
      : TransitionEffect.scale({ x: 0.8, y: 0.8 })
      .combine(TransitionEffect.OPACITY)
      .animation({ duration: 250, curve: Curve.Friction }))
  }

  onEditModeChange() {
    this.viewModel.onEditModeChange(this.isEditMode);
  }

  uiContextRequestFocus(id: string): void {
    try {
      this.getUIContext().getFocusController().requestFocus(id);
    } catch (error) {
      log.showInfo(`requestFocus error: ${error}`);
    }
  }

  private isShowingLibrary(): boolean {
    return this.viewData.showQuickToggleLibrary || this.viewData.showIotLibrary || this.viewData.showTopToggleLibrary;
  }

  private isNarrowScreen(): boolean {
    return ((px2vp(this.screenWidth) - 342) / 2) < 8;
  }

  @Styles
  parentSize() {
    .width('100%')
    .height('100%')
  }
}
