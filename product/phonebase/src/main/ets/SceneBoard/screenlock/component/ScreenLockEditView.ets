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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  GlobalContext,
  ResourceManager,
  sSettingsUtil,
  WallpaperData,
  WallpaperManager
} from '@ohos/frameworkwrapper';
import { AppItemInfo, CardItemInfo, StyleConstants } from '@ohos/launchercommon';
import { DisplayStateListener, DisplayStateManager, SysFloatTipDialog } from '@ohos/screenlockcommon/Index';
import { DisplayUtils, ScreenLockFormConstants } from '@ohos/screenlockcommon';
import curves from '@ohos.curves';
import Want from '@ohos.app.ability.Want';
import { AnyClock } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import ScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';
import { EditToolType } from '@ohos/screenlockwidget/src/main/ets/editsheet/utils/Contants';
import { clockLayoutHelper } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { EventDispatchUtil } from '@ohos/screenlockwidget/src/main/ets/editsheet/utils/EventDispatchUtil';
import { SafeAreaInsets } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/SafeAreaInsets';
import { ScreenLockEditVm } from '../viewmodel/ScreenLockEditVm';
import ActionSheet from '@ohos/screenlockwidget/src/main/ets/editsheet/views/ActionSheet';
import { MainPageVc } from '../controller/MainPageVc';
import { slStateHelper } from '../model/helper/SlStateHelper';
import { slStateHelper as slWidgetStateHelper } from '@ohos/screenlockwidget/src/main/ets/common/utils/SlStateHelper';
import { SlEditorBindState } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/SlEditorBindState';
import { slEditorHelper } from '@ohos/screenlockwidget/src/main/ets/editsheet/utils/EditSheetHelper';
import { text } from '@kit.ArkGraphics2D';
import {
  ClockData,
  clockData,
  ClockDataListener
} from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockData';
import common from '@ohos.app.ability.common';
import { image } from '@kit.ImageKit';
import { MpEventType, MpStateType, MpStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';
import { SlObserverProxy } from '@ohos/screenlockcomponent/src/main/ets/observer/SlObserverProxy';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { MainColor } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/MainColor';

const TAG = 'ScreenLockEditView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const RES_MGR = ResourceManager.getInstance();
const CLOCK_DEFAULT_INSETS_H: number = RES_MGR.getNumberByResource($r('app.float.clocksheet_padding_h'));
const CLOCK_DEFAULT_INSETS_TOP: number = 100;
const CLOCK_DEFAULT_INSETS_BOTTOM: number = 128;

const PAD_POSTER_DEFAULT_INSETS_TOP: number = 107;
const PAD_POSTER_DEFAULT_INSETS_BOTTOM: number = 110.0;

const FORM_PANEL_DEFAULT_HEIGHT: number = 670;
const STATUS_BAR_HEIGHT_SLIDE_MIN: number = 20;

const AIGC_NOT_AVAILABLE: number = -21;
const AIGC_STATE_APPEAR: string = 'appear';
const AIGC_STATE_PRIVACY: string = 'privacy';
const AGREE_AIGC_PRIVACY: string = 'true';
const AIGC_STATEMENT_STATUS: string = 'screenlock_aigc_statement_status';

/**
 * 锁屏编辑页面
 */
@Component
export struct ScreenLockEditView {
  @StorageLink('isPortrait') isPortrait: boolean = true;
  @Provide clockPositionX: number = 0;
  @Link @Watch('onClockStyleChange') clockStyle: AnyClock;
  @Provide hasChangeFont: boolean = false;
  @Link formViewModel: ScreenLockFormViewModel;
  @State isHideTopButton: boolean = false;
  @State showScreenLockPanel: boolean = false;
  @State showDetailPanel: boolean = false;
  @State isShowTheme: boolean = false;
  @State bottomButtonMarginBootom: number = StyleConstants.GESTURE_NAV_BOTTOM_HOTAREA_HEIGHT;
  @Consume isEdited: boolean;
  @Consume isEditClockUp: boolean;
  @Provide selectedToolType: EditToolType = EditToolType.Layout;
  @Consume isSmallFoldOuterScreen: boolean = false
  @State needShowThemeUEC: boolean = false;
  @State themeUECOpacity: number = 1.0;
  @Provide artState: string = AIGC_STATE_APPEAR;
  @Provide isAigcAvailable: boolean = true;
  @Provide isFirstAIGCTip: string = '';

  private persistentId: number = 0;
  private mainPageViewControl?: MainPageVc;
  private screenSizeChangeListener: DisplayStateListener = {
    onScreenSizeChange: (width: number, height: number) => {
      log.showInfo('screen width changes');
      this.mDisplayWidth = clockLayoutHelper.getScreenWidth();
      this.mDisplayHeight = clockLayoutHelper.getScreenHeight();
      let isPortrait = this.mDisplayWidth < this.mDisplayHeight;
      const hMargin = clockLayoutHelper.getHorizontalGridMargin(isPortrait);
      this.safeAreaInsets.leading = hMargin;
      this.safeAreaInsets.trailing = hMargin;
      const layoutAmount = clockLayoutHelper.getLayoutGridAmount(isPortrait);
      this.gridColumns = layoutAmount.x;
      this.gridRows = layoutAmount.y;
      // 刷新缓存
      this.slEditorBindState?.setClockAmount(layoutAmount);
      this.safeAreaInsets.bottom = this.mDisplayHeight -
        this.gridRows * clockLayoutHelper.getLayoutGridWidth(isPortrait) - CLOCK_DEFAULT_INSETS_TOP;
      if (this.curMpState === MpStateType.EDIT_MAIN_PAGE_STATE_FULL) {
        // 美学构图期间屏幕大小发生变化，则切换到时钟编辑样式实现打断处理
        ScreenLockFsmProxy.getInstance(this.persistentId).submitMainPageEvent(MpEventType.ENTER_EDIT_CLOCK);
      }
    }
  };

  private initMpState() {
    this.curMpState =
      this.slObserverProxy.getMpFsmState(this.persistentId, (oldState: MpStateType, newState: MpStateType) => {
        if (oldState === newState) {
          return;
        }
        this.mEditViewModel?.setCurMpState(newState);
        this.mEditViewModel?.updateMpFsmState(oldState, newState);
        if (!MpStateTypeUtils.isEditState(newState)) {
          this.artState = AIGC_STATE_APPEAR;
        }

        if (newState !== MpStateType.EDIT_MAIN_PAGE_STATE_FULL) {
          // 显示应用按钮
          this.slEditorBindState.setButtonAlpha(1);
          // 设置编辑面板缩放比例
          this.slEditorBindState.setLayoutScale(1);
        }

        if (!MpStateTypeUtils.isEditClockState(newState)) {
          this.isHideTopButton = false;
        }

        if (MpStateTypeUtils.isEditPreviewState(newState)) {
          this.artState = AIGC_STATE_APPEAR;
          this.formViewModel.updateLayout(this.clockStyle.layout, this.clockStyle.y);
          this.buttonOpacity = 1;
        }
        if (newState === MpStateType.EDIT_CARD_STATE) {
          this.initFormListHeight();
        }
        this.showScreenLockPanel = newState === MpStateType.EDIT_CARD_STATE;
        if (MpStateTypeUtils.isEditState(oldState) && !MpStateTypeUtils.isEditState(newState)) {
          this.hasChangeFont = false;
          this.isEdited = false;
          this.selectedToolType = EditToolType.Layout;
          slEditorHelper.getLayoutEditManger().clearEditCache();
          this.mainPageViewControl?.getViewModel()?.setExtensionProxy(null);
          this.disappearAnimation(newState);
        } else if (MpStateTypeUtils.isEditState(newState)) {
          this.curMpState = newState;
          log.info(TAG, `Display mode change, curMpState = ${this.curMpState}`);
          if (!MpStateTypeUtils.isEditExtensionState(newState)) {
            EventDispatchUtil.getInstance().handleEvent(this.clickType, 'exit');
          }
        }
        this.curMpState = newState;
      });
    this.mEditViewModel?.setCurMpState(this.curMpState);
  }

  @State safeAreaInsets: SafeAreaInsets = new SafeAreaInsets({
    top: CLOCK_DEFAULT_INSETS_TOP,
    leading: CLOCK_DEFAULT_INSETS_H,
    bottom: CLOCK_DEFAULT_INSETS_BOTTOM,
    trailing: CLOCK_DEFAULT_INSETS_H,
  });
  @State gridColumns: number = 0;
  @State gridRows: number = 0;
  // 卡片列表半模态高度
  @State formListHeight: number = FORM_PANEL_DEFAULT_HEIGHT;
  @State currentFormInfo: AppItemInfo = new AppItemInfo();
  @State currentCardItemInfoList: CardItemInfo[] = new Array();
  @State buttonOpacity: number = 1;
  @State actionBlurRadius: number = 0;
  @State actionOpacity: number = 0;
  @State actionScale: number = 0;
  @State personalizeButtonScale: number = 0;
  @State wallpaperButtonScale: number = 0;
  @State themeButtonScale: number = 0;
  @State aodButtonScale: number = 0;
  @State personalizeButtonOpacity: number = 0;
  @State wallpaperButtonOpacity: number = 0;
  @State themeButtonOpacity: number = 0;
  @State aodButtonOpacity: number = 0;
  @State personalizeButtonBlurRadius: number = 0;
  @State wallpaperButtonBlurRadius: number = 0;
  @State aodButtonBlurRadius: number = 0;
  @State wallpaperData: WallpaperData = WallpaperManager.getInstance().wallpaperData;
  @StorageLink('editorTranslate') editorTranslate: number = 0;
  @StorageLink('wallPaperOpacity') wallPaperOpacity: number = 1;
  @StorageLink('wallPaperBlurRadius') wallPaperBlurRadius: number = 0;
  @State blackOpacity: number = 0;
  @State clickType: string = '';
  @State curMpState: MpStateType = MpStateType.INIT_STATE;
  private startX: number = 0;
  private startY: number = 0;
  private mEditViewModel?: ScreenLockEditVm;
  private mDisplayWidth: number = 0;
  private mDisplayHeight: number = 0;
  private readonly slObserverProxy: SlObserverProxy = new SlObserverProxy();

  // 编辑面板UI绑定状态
  @State private slEditorBindState: SlEditorBindState = slWidgetStateHelper.getEditorBindState();
  @Provide uiExtensionProxy: UIExtensionProxy | undefined = undefined;
  @Provide @Watch('pirvacyDialogstateChange')dialogState: string = '';
  @Provide time: string = '';
  @Consume gridWidth: number;
  @Consume mainColor: MainColor;

  private coverClockData: ClockData = clockData;

  private pirvacyDialogstateChange(): void {
    let opacity = this.dialogState === AIGC_STATE_PRIVACY ? 0 : 1;
    this.hideScrennlockButtonAnim(opacity);
  }

  private clockDataListener: ClockDataListener = {
    onChanged: () => {
      this.time = this.coverClockData.clockTime + ' ' + this.coverClockData.dateStr + ' ' + this.coverClockData.weekStr + ' ' + this.coverClockData.lunarDate;
    }
  }

  private hideScrennlockButtonAnim(opacity: number) {
    animateTo({
      duration: 200,
      curve: curves.cubicBezierCurve(0.4, 0.0, 0.4, 1.0),
    }, () => {
      this.actionOpacity = opacity;
    });
  }

  private disappearAnimation(newState: MpStateType): void {
    if (MpStateTypeUtils.isUnlockState(newState) || MpStateTypeUtils.isFakeAodState(newState)) {
      this.buttonOpacity = 0;
      this.personalizeButtonScale = 0;
      this.wallpaperButtonScale = 0;
      this.aodButtonScale = 0;
      this.themeButtonScale = 0;
      this.curMpState = newState;
      EventDispatchUtil.getInstance().handleEvent(this.clickType, 'exit');
      return;
    }
    animateTo({
      duration: 150,
      curve: curves.cubicBezierCurve(0.4, 0.0, 0.4, 1.0),
      onFinish: () => {
        this.curMpState = newState;
        EventDispatchUtil.getInstance().handleEvent(this.clickType, 'exit');
      }
    }, () => {
      this.buttonOpacity = 0;
    })

    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 30)
    }, () => {
      this.personalizeButtonScale = 0;
      this.wallpaperButtonScale = 0;
      this.aodButtonScale = 0;
      this.themeButtonScale = 0;
    })
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.coverClockData.registerDataChanged(this.clockDataListener);
    DisplayStateManager.getInstance().registerObserver(this.screenSizeChangeListener);
    this.mEditViewModel = new ScreenLockEditVm(this.formViewModel, this.clockStyle);
    this.mEditViewModel.initViewModel(this.persistentId);
    this.initMpState();
    this.mDisplayWidth = clockLayoutHelper.getScreenWidth();
    this.mDisplayHeight = clockLayoutHelper.getScreenHeight();
    const hMargin = clockLayoutHelper.getHorizontalGridMargin(this.isPortrait);
    this.safeAreaInsets.leading = hMargin;
    this.safeAreaInsets.trailing = hMargin;
    const layoutAmount = clockLayoutHelper.getLayoutGridAmount(this.isPortrait);
    this.gridColumns = layoutAmount.x;
    this.gridRows = layoutAmount.y;
    // 刷新缓存
    this.slEditorBindState?.setClockAmount(layoutAmount);
    if (DeviceHelper.isPadOr2in1PcType() || DisplayUtils.isUltraScreenGStatus()) {
      this.initClockLayoutPad();
    }
    this.safeAreaInsets.bottom = this.mDisplayHeight -
      this.gridRows * clockLayoutHelper.getLayoutGridWidth(this.isPortrait) - CLOCK_DEFAULT_INSETS_TOP;
    this.initFormListHeight();
    this.isEdited = false;
    this.checkAigcAvailable();
  }

  private async checkAigcAvailable() {
    if (sSettingsUtil.getSecureValue(AIGC_STATEMENT_STATUS, 'false', GlobalContext.getContext()) ===
      AGREE_AIGC_PRIVACY) {
      log.showInfo('screenlock aigc agree privacy')
      try {
        //let setting: ExtPhotoSetting = ExtPhotoSetting.createExtPhotoSetting();
        const options: image.InitializationOptions = {
          size: { width: 1, height: 1 },
          pixelFormat: image.PixelMapFormat.RGBA_8888, // 像素格式（支持透明度）
        };
        const emptyPixelMap = image.createPixelMapSync(options);
        // let analyzer: ExtPhotoAnalyzer | undefined =
        //   ExtPhotoAnalyzer.createAnalyzer(getContext() as common.UIAbilityContext, setting);
        // analyzer?.fontGenerationRecognize(emptyPixelMap, (err:ESObject, str:String) => {
        //   if (err === AIGC_NOT_AVAILABLE) {
        //     this.isAigcAvailable = false;
        //   }
        // });
      } catch (err) {
        log.showError(`check aigc available fail code: ${err.code}`);
      }
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    DisplayStateManager.getInstance().unRegisterObserver(this.screenSizeChangeListener);
    this.coverClockData.unregisterDataChanged(this.clockDataListener);
    this.mEditViewModel?.destroyViewModel();
    this.slObserverProxy.release();
    text.FontCollection.getGlobalInstance().clearCaches();
  }

  onClockStyleChange() {
    if (!MpStateTypeUtils.isEditState(this.curMpState) || this.curMpState === MpStateType.EDIT_NORMAL_STATE) {
      return;
    }
    this.initFormListHeight();
    this.isEdited = true;
  }

  initClockLayoutPad() {
    const layoutGridAmount = clockLayoutHelper.getLayoutGridAmount(this.isPortrait);
    const singleGridWidth = clockLayoutHelper.getLayoutGridWidth(this.isPortrait);
    const layoutGridWidth = clockLayoutHelper.getLayoutSize(singleGridWidth, layoutGridAmount).width;
    const layoutHorizontailMargin = (this.mDisplayWidth - layoutGridWidth) / 2;
    this.safeAreaInsets.top = PAD_POSTER_DEFAULT_INSETS_TOP;
    this.safeAreaInsets.bottom = PAD_POSTER_DEFAULT_INSETS_BOTTOM;
    this.safeAreaInsets.leading = layoutHorizontailMargin;
    this.safeAreaInsets.trailing = layoutHorizontailMargin;
  }

  private initFormListHeight() {
    if (this.formViewModel.getDownToClockView()) {
      this.formListHeight = px2vp(this.mDisplayHeight) - clockLayoutHelper.getWidgetSize().height -
        this.safeAreaInsets.top -
        this.formViewModel.getFormPanelHeight() * clockLayoutHelper.getLayoutGridWidth(this.isPortrait);
      return;
    }
    this.formListHeight = px2vp(this.mDisplayHeight) - this.safeAreaInsets.top -
      clockLayoutHelper.getLayoutGridAmount(this.isPortrait).y * clockLayoutHelper.getLayoutGridWidth(this.isPortrait);
  }

  private touchMove(event: TouchEvent): void {
    let newY = event.changedTouches[0].screenY;
    let startY = this.startY;

    let moveY = newY - startY;
    log.showDebug(`onTouchEvent Move moveY: ${moveY}`);
    // 滑动距离过小
    if (moveY < STATUS_BAR_HEIGHT_SLIDE_MIN) {
      return;
    }
  }

  build() {
    if (MpStateTypeUtils.isEditState(this.curMpState) || this.needShowThemeUEC) {
      Stack() {
        if (this.isSmallFoldOuterScreen) {
        } else {
          // 蒙黑
          Column()
            .width(StyleConstants.PERCENTAGE_100)
            .height(StyleConstants.PERCENTAGE_100)
            .backgroundColor(Color.Black)
            .opacity(this.blackOpacity)
            .hitTestBehavior(HitTestMode.None)
            .id(TAG + 'BlackLayer')

          Column() {
            ActionSheet({
              isHideTopButton: this.isHideTopButton || this.isEditClockUp,
              showGuide: MpStateTypeUtils.isEditPreviewState(this.curMpState) ||
              MpStateTypeUtils.isEditExtendState(this.curMpState),
              actionScale: $actionScale,
              actionOpacity: $actionOpacity,
              blurRadius: $actionBlurRadius,
              isClockVisable: this.mEditViewModel?.isClockVisible,
              leftCallback: () => {
                this.mEditViewModel?.cancelEdit(this.curMpState);
              },
              rightCallback: () => {
                this.mEditViewModel?.applyThemeConfig();
              }
            })
              .opacity(this.buttonOpacity)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .height('100%')
          .hitTestBehavior(HitTestMode.Transparent)

          Stack({ alignContent: Alignment.Bottom }) {
            SysFloatTipDialog({ componentId: ScreenLockFormConstants.THEME_EDITOR_TIP_DIALOG })
          }
          .width('100%')
          .height('100%')
          .hitTestBehavior(HitTestMode.None)


          Row()
            .accessibilityLevel('no')
            .position({ x: 0, y: 0 })
            .width('100%')
            .height($r('app.float.statusbar_hot_area_height'))
            .opacity(0)
            .hitTestBehavior(HitTestMode.Transparent)
            .onTouch((event?: TouchEvent) => {
              if (!event) {
                return;
              }
              switch (event.type) {
                case TouchType.Down:
                  log.showInfo('onTouchEvent Down');
                  // 记录Down点
                  this.startX = event.changedTouches[0].screenX;
                  this.startY = event.changedTouches[0].screenY;
                  log.showInfo(`onTouchEvent touchStart, startX: ${this.startX}, startY: ${this.startY}`);
                  break;
                case TouchType.Move:
                  this.touchMove(event);
                  break;
                default:
                  break;
              }
            })
        }

      }
      .align(Alignment.Top)
      .size({
        width: '100%',
        height: '100%',
      })
      .hitTestBehavior(HitTestMode.Transparent)
    }
  }
}