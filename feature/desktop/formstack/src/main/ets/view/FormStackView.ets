/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import curves from '@ohos.curves';
import display from '@ohos.display';
import type image from '@ohos.multimedia.image';
import { componentSnapshot, ImageModifier, performanceMonitor } from '@kit.ArkUI';
import {
  CommonConstants,
  DesktopUtils,
  StyleConstants,
  PresetStyleConstants,
  CardItemInfo,
  launcherAbilityManager,
  MenuInfoManager,
  EditModeUtils,
  Extend1Data,
  GridLayoutUtil,
  ScreenSplitUtil,
  MenuInfo,
  EventConstants,
  NoIconAppModel,
  FormLayoutCacheManager,
  EditModeConstants,
  FormStackEventIdUtil,
  FormCommonUtil,
  PageDesktopModel,
  BundleConstants,
  RdbStoreManager,
  LayoutViewModel,
  ReceiveEventInfo,
  lockLayoutManager,
  DesktopDragResult,
} from '@ohos/launchercommon';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  TraceUtil,
  DomainName,
  RectInfo,
  CommonUtils,
  SingleContext
} from '@ohos/basicutils';
import {
  GlobalContext,
  ResourceManager,
  SceneIdentificationManager,
  SceneState,
  AccessibilityManager,
  localEventManager,
  EvtBus
} from '@ohos/frameworkwrapper';
import { NumberConstants, SCBConstants } from '@ohos/commonconstants';
import { AiSuggestionConstants,
  LongPressType } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { DragEventManager } from '@ohos/componentdrag';
import { DropAnimationCancelReason,
  DropAnimationDestination,
  DropAnimationListener, dropAnimationObserver,
  DropAnimationParam } from '@ohos/componentanimator';
import { dragSnapshotHelper, ItemUtils, SnapshotType, ObjectCopyUtil,
  DragAccessibilityUtils,
  StateEx} from '@ohos/componenthelper';
import { ResUtils, SCBTransitionManager, scbEventExclusiveManager, EventType,
  launcherStatusUtil } from '@ohos/windowscene';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { DeviceState } from '@ohos/launchercommon';
import { FormRelationManager } from '@ohos/launchercommon';
import { FormConstants, FormViewModel } from '@ohos/form';
import {
  nameAppearAnimate,
  MenuCommonUtil,
  HoverAnimationUtil,
  launcherVisualEffectMgr,
  FormDFXUtil,
} from '@ohos/launchercommon/Index';
import { EditModeState } from '@ohos/launchercommon/src/main/ets/editmode/data/EditModeState';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import {
  FormComponentConfig,
  FormComponentDisplayStyle,
} from '@ohos/launchercommon/src/main/ets/form/model/FormComponentConfig';
import { EventInfo } from '../common/EventInfo';
import { FormStackItemInfo } from '../common/FormStackItemInfo';
import { FormStackStyleConstants } from '../common/FormStackStyleConstants';
import { FormStackDataAdapt, FormStackMsg } from '../common/FormStackDataAdapt';
import { FormStackConstants } from '../common/FormStackConstants';
import { FormStackSlideAnimate, SlideAnimateParam } from '../common/FormStackSlideAnimate';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackManager } from '../common/FormStackManager';
import {
  FormStackHiSysEventUtil,
  SwitchCardsEvent,
  SwitchCardsSlideType,
  FormStackExpandEventParam,
  ShortcutMenuClickEvent,
  ShortcutMenuClickItem,
} from '../common/FormStackHiSysEventUtil';
import { FormStackAnimateItem, OpenFormStackStateInfo } from '../viewmodel/FormStackAnimateItem';
import { FormStackAnimate, SlideOperateType } from '../viewmodel/FormStackAnimate';
import { FormStackViewModel } from '../viewmodel/FormStackViewModel';
import { FormStackMenuViewModel } from '../viewmodel/FormStackMenuViewModel';
import { FormStackEvent } from '../viewmodel/FormStackEvent';
import FormStackMenu from './FormStackMenu';
import {
  SecondFormMask,
  FormStackBackboard,
  FormStackMask,
  FormStackCoverImage
} from './FormStackMaskView';
import { FormStackItemView } from './FormStackItemView';
import { FormAppName } from './FormAppName';
import { BusinessError } from '@kit.BasicServicesKit';
import { AiSuggestionUtil } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUtil';
import {
  VoiceInStackExposeEvent, createVoiceInStackExposeEvent
} from '@ohos/launchercommon/src/main/ets/aisuggestion/VoiceInStackExposeEvent';

const TAG: string = 'FormStackView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

// 菜单项的group数
const GROUP_NUM = 2;

enum CardAreaType {
  SMALL,
  MIDDLE,
  LARGE
};
const BLEND_MODE_SRC_OVER: number = 4;
const UPDATE_CARD_ORDER_DELAY: number = 5000;

@Component
export struct FormStackView {
  @Prop singleContext?: SingleContext;
  @Consume('openFormStackFlag') @Watch('openFormStackFlagChange') openFormStackFlag: boolean;
  @Consume('formStackTouchStatus') isFormStackTouch: boolean;
  @State isToOpenFormStack: boolean = false;
  @State isMenuAppear: boolean = false;
  private mFormItemList: CardItemInfo[] = [];
  private mFormStackItem: FormStackItemInfo = new FormStackItemInfo();
  private readonly mIconNameMargin: number = PresetStyleConstants.DEFAULT_ICON_NAME_GAP;
  private readonly marginLeft: number = PresetStyleConstants.DEFAULT_DESKTOP_NAME_MARGIN;
  private readonly mFormStackNameHeight?: number;
  private readonly mFormStackNameWidth?: number;
  private readonly mFormStackNameSize?: number;
  private readonly mNameFontColor?: string;
  private readonly mNameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  @Prop private readonly mFormStackItemWidth: number = 0;
  @Prop private readonly mFormStackItemHeight: number = 0;
  private isOuterDesktop: boolean = false;
  @State editModeState: EditModeState = editModeManager.getEditModeState();
  @Prop @Watch('radiusChange') mFormBorderRadius: number = ResourceManager.getInstance()
    .getNumberByResource($r('app.float.form_corner_radius'));
  private mSlideStartTime: number = 0;
  private mSizeRatio: number = 0;
  private mFixedOffsetY: number = 0;
  private mCurrentFormItem: CardItemInfo = new CardItemInfo();
  @Link menuName: string;
  private mFormStackMenuViewModel?: FormStackMenuViewModel;
  private readonly mDragStartFun?: Function;
  private needUpdateDragSnapShot: boolean = false;

  @State private mIsFormStackBackgroundOpen: boolean = false;
  @State private mFormStackMaskOpacity: number = 0;
  @State private mFormStackScale: number = 1;
  @State private mFormStackOffset: number = 0;
  private mFormBackboardOffsetY: number = 0;
  @State mFormBackboardScale: number = 1;
  @State mFormBackboardRadiusOffset: number = 0;
  @State mFormBackboardOffset: number = 0;

  private displayInfo?: display.Display = this.getDefaultDisplaySync();
  @State formStackAppName: string = '';
  @State mViewModel: FormStackAnimate = new FormStackAnimate();
  private lastMoveY: number = 0; // 上一次移动距离
  private slideMoveY: number = 0; // 当前移动距离
  private mSlideDownThreshold: number = 0;
  private mSlideUpThreshold: number = 0;
  private slideFormIndex = 0; // 滑动卡片的索引
  private mSlideAnimate: FormStackSlideAnimate = new FormStackSlideAnimate();
  private isDragging: boolean = false;
  private isLast: boolean = true;
  @State lastName: string = '';
  @State lastNameOpacity: number = 1;
  @State nextName: string = '';
  @State nextNameOpacity: number = 0;
  @Provide('formStackAnimateState') mAnimateState: SlideOperateType = SlideOperateType.DEFAULT_STATE;
  private mSlideCount: number = 0;
  private isListChangeByEdit: boolean = false;
  private getIndexInSwiper: Function = (): number => 0;
  private isMenuClicked: boolean = false;
  private mFormStackViewModel : FormStackViewModel = new FormStackViewModel();
  private mIconNameMarginTop: number = PresetStyleConstants.DEFAULT_ICON_NAME_GAP;
  private mPressCurve?: curves.ICurve;
  private mPressScale: number = 1;
  private formStackMenuInfoList?: MenuInfo[] = [];
  private cardMenuInfoList?: MenuInfo[] = [];
  @State formItemComponentScale: ScaleOptions = {
    x: NumberConstants.CONSTANT_NUMBER_ONE,
    y: NumberConstants.CONSTANT_NUMBER_ONE
  };
  @State formItemHoverScale: ScaleOptions = {
    x: NumberConstants.CONSTANT_NUMBER_ONE,
    y: NumberConstants.CONSTANT_NUMBER_ONE
  };
  private mEvent: FormStackEvent = new FormStackEvent();
  private mDefaultSlideDownThreshold: number = 0;
  private mOuterDefaultSlideDownThreshold: number = 0;
  private mCardSlideDownMaxDistance: number = 0;
  private mCardOpacityChangeSlideRatio: number = 0;
  private mCardOpacityChangeInterval: number = 0;
  private readonly mGetRemoveFormTitleFun?: Function;
  @State formNameOpacity: number = 1;
  @StorageLink('isDrag') isDrag: boolean = false;
  @StorageLink('isInGridSwiperGesture') isInGridSwiperGesture: boolean = false;
  @Link @Watch('getBlendModeParam') isNeedBlendMode: boolean;
  @State blendModeParam: BlendModeParam = new BlendModeParam();
  @State mFormStackTopCardId: string = '';
  @State mFormStackForeachList: FormStackAnimateItem[] = [];
  @State menuPlacement: Placement = Placement.BottomLeft;
  @State isHiddenEffect: boolean = false;
  @Consume dragSnapshot?: image.PixelMap;
  @Link mDialogName: Resource;
  @State showMenu: boolean = false;
  @State mStaticMaskExtraWidth: number = 0;
  @State isBlurAnimRunning: StateEx<boolean> = launcherVisualEffectMgr.isBlurAnimRunning;
  @Consume @Watch('isEqualToDragItemChange') isDragStart: boolean;
  @Consume isInDrag: boolean;
  @StorageProp('lockReceived') @Watch('onLockReceived') mLockReceived: number = 0;
  @StorageLink('currColorMode') @Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @StorageLink('folderStatusMenu') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('desktopAppNameChange') @Watch('onLanguageChange') language: string = '';
  private otherIconLongPressEffectCancelFunc: () => void = (): void => this.cancelLongPressAnimation();
  private mFormStackBuilderId: string = '';
  private mCoverFormItem?: CardItemInfo;
  private mDeleteCardToRefreshDesktopSign: boolean = false;
  private updateCardOrder = CommonUtils.debounce(() => {
    // 解析intentInfo
    const formGridItem: GridLayoutItemInfo = this.mFormStackItem as object as GridLayoutItemInfo;
    const intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(formGridItem.intent);
    intentMap.set('cardOrder', this.mFormStackItem.layoutInfo[0].map(i => i.cardId));
    const intendInfo: string = CommonUtils.mapToJsonStr(intentMap);
    log.showInfo(`update cardOrder, intendInfo = ${intendInfo}`);
    if (CheckEmptyUtils.checkStrIsEmpty(intendInfo)) {
      return;
    }
    RdbStoreManager.getInstance().updateIntendInfoByInfoId(this.mFormStackItem.formStackId, intendInfo,
      this.isOuterDesktop, LayoutViewModel.getInstance().isSimpleLauncherMode());
  }, UPDATE_CARD_ORDER_DELAY);

  private deleteFormStackFunc: () => void = () => {
    // 堆叠删卡后聚焦父组件
    this.updateAccessibilityFocusWhenDelete();
    this.mEvent.deleteFormFromStack(this.mCurrentFormItem);
    this.mDeleteCardToRefreshDesktopSign = true;
  };
  private getDefaultDisplaySync(): display.Display | undefined {
    try {
      return display.getDefaultDisplaySync();
    } catch (e) {
      log.showError(`getDefaultDisplaySync code: ${e?.code}, msg: ${e?.message}`);
    }
    return undefined;
  }
  private topCardSnapshot: image.PixelMap | null = null;

  private onLanguageChange(): void {
    // 切换语言时刷新堆叠名称,语音助手建议卡片通过updateAppName回调刷新
    if (AiSuggestionUtil.isVoiceAbilityForm(this.mCurrentFormItem.bundleName, this.mCurrentFormItem.abilityName)) {
      return;
    }
    this.showTopCardName(this.mFormStackTopCardId);
  }

  private getDialogName(): void {
    ResourceManager.getInstance().getAppNameWithCache(
      this.mCurrentFormItem.appLabelId, this.mCurrentFormItem.bundleName,
      this.mCurrentFormItem.moduleName, '', (value: string) => this.updateDialogName(value));
  }

  private updateDialogName(value: string): void {
    // 将系统替换场景的SceneBoard应用名称替换为设备应用名称
    if (FormRelationManager.getInstance().isSceneBoardCard(
      this.mCurrentFormItem.bundleName, this.mCurrentFormItem.cardName)) {
      let appName: string = FormRelationManager.getInstance().getAppNameByCardId(this.mCurrentFormItem.cardId);
      if (!CheckEmptyUtils.checkStrIsEmpty(appName)) {
        log.showInfo(`set appName : ${appName}`);
        value = appName;
      }
    }
    this.mDialogName = this.mGetRemoveFormTitleFun?.(value);
  }

  private onColorModeChange(): void {
    log.showInfo(`onColorModeChange, currDarkMode is: ${this.currColorMode}`);
  }

  private folderStatusChange() {
    if (launcherStatusUtil.isCurrentDesktopVisible(this.isOuterDesktop) && this.mDeleteCardToRefreshDesktopSign) {
      log.showInfo('delete card to refresh inner desktop');
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_INNER_PAGEDESK_LIGHT_REFRESH, null);
      this.mDeleteCardToRefreshDesktopSign = false;
    }
    if (this.isMenuAppear) {
      this.isHiddenEffect = true;
    }
  }

  private isEqualToDragItemChange(): void {
    log.showInfo('isEqualToDragItemChange, isDragStart:%{public}s', this.isDragStart);
    if (!this.isDragStart) {
      this.formNameOpacity = 0;
      GlobalContext.getContext()?.eventHub.emit(`mFormStackPressTypeChange_${this.mFormStackTopCardId}`,
        LongPressType.DEFAULT);
      nameAppearAnimate(() => this.formNameOpacity = 1);
    }
  }

  private slideInitData(slideDistance: number): void {
    if (this.isAnimateListInvalid()) {
      return;
    }
    log.showInfo(`slide init data, slideDistance: ${slideDistance}`);
    this.mEvent.breakAnimation(false, () => {
      this.mViewModel.resetFormStackStatus();
    });
    if (slideDistance > 0) {
      // 下滑
      this.mViewModel.mMaskList[1].mScaleX = this.mSizeRatio;
      this.mViewModel.mMaskList[1].mScaleY = this.mSizeRatio;
      this.mViewModel.mMaskList[1].mRotateAngle =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).behindFormRotateAngle;
      this.mViewModel.mMaskList[1].mOpacity = 0.9;
      this.mViewModel.mMaskList[1].mIsOffsetY = this.mFormItemList.length > 2;
      this.mViewModel.mMaskList[1].zIndex = this.mFormItemList.length > 2 ? (this.slideFormIndex - 1) * 2 - 1 : -1;
      this.mViewModel.mMaskList[1].mVisible = true;
    } else {
      // 上滑
      this.mViewModel.mMaskList[1].mVisible = true;
      this.mViewModel.mItemInfoList[0].mTranslateY = this.mFormStackItemHeight + Math.abs(this.mFixedOffsetY);
      this.mViewModel.mItemInfoList[0].mScaleX =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalScaleX;
      this.mViewModel.mItemInfoList[0].mScaleY =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalScaleY;
      this.mViewModel.mItemInfoList[0].mRotateAngle =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalRotateAngle;
      this.mViewModel.mItemInfoList[0].mOpacity = 0;
      this.mViewModel.mItemInfoList[0].zIndex = this.slideFormIndex * 2 + 2;
    }
  }

  private slideMoveAnimate(slideDistance: number): void {
    if (this.isAnimateListInvalid() || this.mFormStackItemHeight <= 0) {
      log.showError('basic param invalid, can not slide move')
      return;
    }

    let dampingRatio: number = 0;
    let realSlideDistance: number = slideDistance;
    let mOpacityRatio: number = 0;
    if (realSlideDistance > 0) {
      dampingRatio = slideDistance / this.mSlideDownThreshold;
      if (editModeManager.isInEditMode()) {
        if (dampingRatio > 1) {
          // 跟手达到极限距离，则此次操作不响应
          return;
        }
      } else if (dampingRatio >= 1 && !this.isToOpenFormStack) {
        // 滑动超过阈值表示要展开卡片了
        log.showInfo('slide down max, going to open stack form');
        performanceMonitor.end(FormStackConstants.SLIDE_TO_SWITCH_CARD_DOT);
        FormStackUtil.playVibration(true);
        this.openFormStack(false);
        return;
      }
      realSlideDistance = this.mCardSlideDownMaxDistance * dampingRatio;
      mOpacityRatio = realSlideDistance < this.mCardOpacityChangeSlideRatio ? 0 :
        FormStackConstants.SLIDE_DOWN_OPACITY_CHANGE_DISTANCE_RATIO *
        (realSlideDistance - this.mCardOpacityChangeSlideRatio) / this.mCardOpacityChangeInterval;
    } else {
      dampingRatio = slideDistance / this.mSlideUpThreshold;
      if (dampingRatio > 1) {
        // 跟手达到极限距离，则此次操作不响应
        return;
      }

      realSlideDistance = -this.mFormStackItemHeight * dampingRatio;
    }
    this.slideMoveDetail(realSlideDistance, dampingRatio, mOpacityRatio);
  }

  private slideMoveDetail(realSlideDistance: number, dampingRatio: number, opacityRatio: number): void {
    if (realSlideDistance > 0) {
      // 下滑
      this.mViewModel.mItemInfoList[this.slideFormIndex].mTranslateY = realSlideDistance;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mScaleX =
        1 + ((this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downMaxScaleX - 1) * dampingRatio;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mScaleY = 1 +
        ((this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downMaxScaleY - 1) * dampingRatio;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mRotateAngle =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downMaxRotateAngle * dampingRatio;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mOpacity = 1 - opacityRatio;

      this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mTranslateY = Math.abs(this.mFixedOffsetY) * dampingRatio;
      this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mScaleX =
        this.mSizeRatio + (1 - this.mSizeRatio) * dampingRatio;
      this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mScaleY =
        this.mSizeRatio + (1 - this.mSizeRatio) * dampingRatio;
      this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mRotateAngle =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).behindFormRotateAngle * (1 - dampingRatio);

      this.mViewModel.mMaskList[0].mTranslateY = Math.abs(this.mFixedOffsetY) * dampingRatio;
      this.mViewModel.mMaskList[0].mScaleX = this.mSizeRatio + (1 - this.mSizeRatio) * dampingRatio;
      this.mViewModel.mMaskList[0].mScaleY = this.mSizeRatio + (1 - this.mSizeRatio) * dampingRatio;
      this.mViewModel.mMaskList[0].mRotateAngle =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).behindFormRotateAngle * (1 - dampingRatio);
      this.mViewModel.mMaskList[0].mOpacity = 0.9 * (1 - dampingRatio);
    } else {
      // 上滑
      this.mViewModel.mItemInfoList[0].mTranslateY = this.mFormStackItemHeight +
        Math.abs(this.mFixedOffsetY) + realSlideDistance;
      this.mViewModel.mItemInfoList[0].mScaleX =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalScaleX +
          (1 - (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalScaleX) * dampingRatio;
      this.mViewModel.mItemInfoList[0].mScaleY =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalScaleY +
          (1 - (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalScaleY) * dampingRatio;
      this.mViewModel.mItemInfoList[0].mRotateAngle =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalRotateAngle * (1 - dampingRatio);
      this.mViewModel.mItemInfoList[0].mOpacity = dampingRatio;

      this.mViewModel.mItemInfoList[this.slideFormIndex].mTranslateY = -(Math.abs(this.mFixedOffsetY * dampingRatio));
      this.mViewModel.mItemInfoList[this.slideFormIndex].mScaleX = 1 - (1 - this.mSizeRatio) * dampingRatio;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mScaleY = 1 - (1 - this.mSizeRatio) * dampingRatio;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mRotateAngle =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).behindFormRotateAngle * dampingRatio;

      this.mViewModel.mMaskList[1].mTranslateY = -(Math.abs(this.mFixedOffsetY * dampingRatio));
      this.mViewModel.mMaskList[1].mScaleX = 1 - (1 - this.mSizeRatio) * dampingRatio;
      this.mViewModel.mMaskList[1].mScaleY = 1 - (1 - this.mSizeRatio) * dampingRatio;
      this.mViewModel.mMaskList[1].mRotateAngle =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).behindFormRotateAngle * dampingRatio;
      this.mViewModel.mMaskList[1].mOpacity = 0.9 * dampingRatio;
    }
  }

  private resetFormStackOfMisSlide(): void {
    if (this.mSlideStartTime === 0) {
      // 未触发滑动不处理
      return;
    }

    // 误触还原
    this.mAnimateState = this.slideMoveY > 0 ? SlideOperateType.SLIDE_DOWN_FAIL : SlideOperateType.SLIDE_UP_FAIL;
    this.resetStackFormStatus();
    this.mSlideStartTime = 0;
  }

  private resetStackFormStatus(): void {
    this.mViewModel.resetFormStackWhenSlideFinished(this.mAnimateState);
    this.mAnimateState = SlideOperateType.DEFAULT_STATE;
  }

  private dealAnimateFinish(): void {
    if (this.mSlideCount === 1 &&
      this.mAnimateState !== SlideOperateType.DEFAULT_STATE &&
      !this.isAnimateListInvalid() && this.mSlideStartTime === 0) {
      log.showInfo('slide animate finished, reset form stack');
      this.resetStackFormStatus();
    }
    this.mSlideCount--;
    log.showInfo(`slide count minus one: ${this.mSlideCount}`);
  }

  private slideUpAnimate(): void {
    if (this.isAnimateListInvalid()) {
      return;
    }

    this.reportSlideResult(SwitchCardsSlideType.SLIDE_UP, this.mViewModel.mItemInfoList[0].bundleName);
    this.notifySlideItem(true);
    performanceMonitor.begin(FormStackConstants.FORMSTACK_SLIDE_UP, performanceMonitor.ActionType.LAST_UP);
    TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_SLIDE_UP);
    this.mAnimateState = SlideOperateType.SLIDE_UP_SUCCESS;
    animateToImmediately({
      curve: curves.springMotion(0.5, 0.9),
      onFinish: () => {
        performanceMonitor.end(FormStackConstants.SLIDE_TO_SWITCH_CARD_DOT);
        performanceMonitor.end(FormStackConstants.FORMSTACK_SLIDE_UP);
        this.dealAnimateFinish();
        TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_SLIDE_UP);
      }
    }, () => {
      this.mViewModel.mItemInfoList[0].mTranslateY = Math.abs(this.mFixedOffsetY);
      this.mViewModel.mItemInfoList[0].mScaleX = 1;
      this.mViewModel.mItemInfoList[0].mScaleY = 1;
      this.mViewModel.mItemInfoList[0].mRotateAngle = 0;
      this.mViewModel.mItemInfoList[0].mOpacity = 1;
      this.mViewModel.mItemInfoList[0].mBorderRadius = this.mFormBorderRadius;

      this.mViewModel.mItemInfoList[this.slideFormIndex].mTranslateY = this.mFixedOffsetY;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mScaleX = this.mSizeRatio;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mScaleY = this.mSizeRatio;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mRotateAngle =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).behindFormRotateAngle;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mBorderRadius =
        this.mFormBorderRadius + FormStackStyleConstants.CARD_BORDER_RADIUS_ADDED;

      this.mViewModel.mMaskList[1].mTranslateY = this.mFixedOffsetY;
      this.mViewModel.mMaskList[1].mScaleX = this.mSizeRatio;
      this.mViewModel.mMaskList[1].mScaleY = this.mSizeRatio;
      this.mViewModel.mMaskList[1].mRotateAngle =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).behindFormRotateAngle;
      this.mViewModel.mMaskList[1].mOpacity = 0.9;
    });
    this.mViewModel.mItemInfoList[0].mIsSupportShadow = true;
    this.mViewModel.mItemInfoList[this.slideFormIndex].mIsSupportShadow = false;
    this.formNameAnimate(this.mFormItemList[0].cardId);
    this.switchBottomCardToTop();
    this.mViewModel.mItemInfoList[0].mClickable = true;
  }

  private slideDownAnimate(): void {
    if (this.isAnimateListInvalid()) {
      return;
    }
    this.reportSlideResult(SwitchCardsSlideType.SLIDE_DOWN,
      this.mViewModel.mItemInfoList[this.slideFormIndex - 1].bundleName);
    this.notifySlideItem(false);
    performanceMonitor.begin(FormStackConstants.FORMSTACK_SLIDE_DOWN, performanceMonitor.ActionType.LAST_UP);
    TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_SLIDE_DOWN_TOP_CARD);
    this.mAnimateState = SlideOperateType.SLIDE_DOWN_SUCCESS;
    let currentTranslateY: number = this.mViewModel.mItemInfoList[this.slideFormIndex].mTranslateY;
    let translateY: number = (currentTranslateY +
      FormStackConstants.SLIDE_DOWN_SUCCESS_FIRST_FORM_TRANSLATE_RATIO * this.mFormStackItemHeight);
    if (this.mFormItemList.length === 2) { // 塞入一张截图
      this.mViewModel.mMaskList[1].snapshot = this.topCardSnapshot;
      this.topCardSnapshot = null;
    }
    animateToImmediately({
      curve: curves.springMotion(0.5, 1),
      onFinish: () => {
        performanceMonitor.end(FormStackConstants.SLIDE_TO_SWITCH_CARD_DOT);
        performanceMonitor.end(FormStackConstants.FORMSTACK_SLIDE_DOWN);
        this.dealAnimateFinish();
        TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_SLIDE_DOWN_TOP_CARD);
      }
    }, () => {
      // 顶部卡片
      this.mViewModel.mItemInfoList[this.slideFormIndex].mTranslateY =
        translateY > this.mFormStackItemHeight ? this.mFormStackItemHeight : translateY;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mScaleX =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalScaleX;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mScaleY =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalScaleY;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mRotateAngle =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalRotateAngle;
      this.mViewModel.mItemInfoList[this.slideFormIndex].mOpacity = 0;
    })
    TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_SLIDE_DOWN_SECOND_CARD);
    animateToImmediately({
      curve: curves.springMotion(0.5, 0.8),
      onFinish: () => {
        TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_SLIDE_DOWN_SECOND_CARD);
      }
    }, () => {
      // 第二张卡片
      this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mTranslateY = Math.abs(this.mFixedOffsetY);
      this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mScaleX = 1;
      this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mScaleY = 1;
      this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mRotateAngle = 0;
      this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mBorderRadius = this.mFormBorderRadius;
      this.mViewModel.mMaskList[0].mTranslateY = Math.abs(this.mFixedOffsetY);
      this.mViewModel.mMaskList[0].mScaleX = 1;
      this.mViewModel.mMaskList[0].mScaleY = 1;
      this.mViewModel.mMaskList[0].mOpacity = 0;
      this.mViewModel.mMaskList[0].mVisible = false;
      if (this.mFormItemList.length === 2) {
        this.mViewModel.mMaskList[1].mTranslateY = this.mFixedOffsetY;
      }
    })
    this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mIsSupportShadow = true;
    this.mViewModel.mItemInfoList[this.slideFormIndex].mIsSupportShadow = false;
    this.formNameAnimate(this.mFormItemList[this.slideFormIndex - 1].cardId);
    this.switchNextCardToTop();
    this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mClickable = true;
  }

  private slideBackAnimate(): void {
    if (this.isAnimateListInvalid()) {
      return;
    }

    performanceMonitor.begin(FormStackConstants.FORMSTACK_SLIDE_BACK, performanceMonitor.ActionType.LAST_UP);
    TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_SLIDE_BACK);
    this.mAnimateState = this.slideMoveY > 0 ? SlideOperateType.SLIDE_DOWN_FAIL : SlideOperateType.SLIDE_UP_FAIL;
    animateTo({
      curve: curves.springMotion(0.5, 0.8),
      onFinish: () => {
        performanceMonitor.end(FormStackConstants.SLIDE_TO_SWITCH_CARD_DOT);
        performanceMonitor.end(FormStackConstants.FORMSTACK_SLIDE_BACK);
        this.dealAnimateFinish();
        TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_SLIDE_BACK);
      }
    }, () => {
      this.restoreFormParam(true);
    });

    if (this.slideMoveY <= 0) {
      this.maskDownshiftAnimate(false);
    }
    this.mViewModel.mItemInfoList[this.slideFormIndex].mClickable = true;
  }

  private restoreFormParam(isNeedAnimate: boolean): void {
    log.showInfo('start restore form param');
    this.mViewModel.mItemInfoList[this.slideFormIndex].mTranslateY = 0;
    this.mViewModel.mItemInfoList[this.slideFormIndex].mScaleX = 1;
    this.mViewModel.mItemInfoList[this.slideFormIndex].mScaleY = 1;
    this.mViewModel.mItemInfoList[this.slideFormIndex].mRotateAngle = 0;
    this.mViewModel.mItemInfoList[this.slideFormIndex].mOpacity = 1;

    this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mTranslateY = 0;
    this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mScaleX = this.mSizeRatio;
    this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mScaleY = this.mSizeRatio;
    this.mViewModel.mItemInfoList[this.slideFormIndex - 1].mRotateAngle =
      (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).behindFormRotateAngle;

    if (this.slideMoveY < 0) {
      this.mViewModel.mItemInfoList[0].mTranslateY = this.mFormStackItemHeight + Math.abs(this.mFixedOffsetY);
      this.mViewModel.mItemInfoList[0].mScaleX =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalScaleX;
      this.mViewModel.mItemInfoList[0].mScaleY =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalScaleY;
      this.mViewModel.mItemInfoList[0].mRotateAngle =
        (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downFinalRotateAngle;
      this.mViewModel.mItemInfoList[0].mOpacity = 0;
      this.mViewModel.mItemInfoList[0].zIndex = this.slideFormIndex * 2 + 2;
    } else {
      this.mViewModel.resetFormState(0);
    }

    if (isNeedAnimate) {
      this.mViewModel.resetMaskState(this.slideMoveY > 0);
    } else {
      this.mViewModel.resetMaskList();
    }
  }

  private openFormStack(isByMenu: boolean): void {
    AppStorage.SetOrCreate<boolean>('stackDesktopState', this.isOuterDesktop);
    if (this.isOuterDesktop !== launcherStatusUtil.getShowOutLauncherStatus()) {
      this.isToOpenFormStack = false;
      this.openFormStackFlag = false;
      return;
    }
    if (CheckEmptyUtils.isEmptyArr(this.mFormItemList) || this.mFormItemList.length <= this.slideFormIndex) {
      log.showError('open form stack param is invalid');
      return;
    }

    TraceUtil.traceOnce(DomainName.SCB, TraceUtil.CORE_METHOD_FS_OPEN_EXPAND_VIEW);
    // 堆叠卡片类型校验修正，所有卡片类型无效时不允许展开
    if (!this.fixCardDimension()) {
      log.showError('form stack card type invalid, unable to expand');
      return;
    }

    log.showWarn(`opening form stack, isByMenu: ${isByMenu}`);
    this.isToOpenFormStack = true;
    let openInfo: OpenFormStackStateInfo = this.buildExpandItemInfo(isByMenu);
    if (!isByMenu) {
      const event: FormStackExpandEventParam = {
        formStackID: this.mFormStackItem.formStackId as string,
        area: this.mFormStackItem.area,
        page: this.mFormStackItem.page,
        column: this.mFormStackItem.column,
        row: this.mFormStackItem.row,
        cardNum: this.mFormStackItem.layoutInfo[0].length,
      };
      FormStackHiSysEventUtil.reportLongSlideDownExpand(event);
    }
    this.syncFormStackLayout();
    FormStackDataAdapt.getInstance().handleMsg<OpenFormStackStateInfo>(
      FormStackMsg.OPEN_FORM_STACK_CRITICAL_INFO, openInfo);
    FormStackDataAdapt.getInstance().handleMsg<FormStackItemInfo>(
      FormStackMsg.SET_FORM_STACK_ITEM_INFO, this.mFormStackItem);
    // 滑动展开后，还原堆叠状态
    this.mAnimateState = this.slideMoveY > 0 ? SlideOperateType.SLIDE_DOWN_FAIL : SlideOperateType.SLIDE_UP_FAIL;
    this.resetStackFormStatus();
    // 堆叠卡片展开时，名称渐隐
    this.formNameAnimate('', true);
    SceneIdentificationManager.notify(SceneState.FORM_STACK_OPEN);
    this.notifySlideItem();
  }

  private formNameAnimate(cardId: string, isDisappear?: boolean, callback?: () => void): void {
    log.showInfo(`start appName animate of formId: ${cardId}.`);

    this.isLast = !this.isLast;
    this.showTopCardName(cardId);

    log.showInfo('formNameAnimate: isLast: %{public}s, lastName: %{public}s, nextName: %{public}s, lastNameOpacity: ' +
      '%{public}d, nextNameOpacity: %{public}d.', this.isLast, this.lastName, this.nextName, this.lastNameOpacity,
      this.nextNameOpacity);
    animateTo({
      duration: 250,
      curve: Curve.Sharp,
      onFinish: () => {
        callback?.();
      },
    }, () => {
      if (this.isLast) {
        this.nextNameOpacity = 0;
      } else {
        this.lastNameOpacity = 0;
      }
    });

    if (isDisappear) {
      return;
    }

    animateTo({
      delay: 200,
      duration: 250,
      curve: Curve.Sharp,
      onFinish: () => {
        callback?.();
      }
    }, () => {
      if (this.isLast) {
        this.lastNameOpacity = 1;
      } else {
        this.nextNameOpacity = 1;
      }
    });
  }

  private appNameLoadCallback(formName: string, topCard: CardItemInfo) {
    log.showInfo(`appNameLoadCallback : ${formName}`);
    this.menuName = formName;
    this.mCurrentFormItem = topCard;

    if (this.isLast) {
      this.lastName = formName;
    } else {
      this.nextName = formName;
    }

    this.updateDialogName(formName);
    FormStackManager.getInstance().setStackName(formName);
    log.showWarn('form name load, name: %{public}s lastName: %{public}s nextName: %{public}s.', formName, this.lastName,
      this.nextName);
  }

  private async showTopCardName(cardId: string): Promise<void> {
    log.showInfo(`card switch to top, cardId: ${cardId}.`);
    let item: CardItemInfo =
      this.mFormItemList.find(element => cardId === element.cardId) as CardItemInfo;
    if (!CheckEmptyUtils.checkStrIsEmpty(cardId) && !item) {
      log.showWarn('show top card name failed, cannot find item');
      return;
    }

    if (!AiSuggestionUtil.isVoiceAbilityForm(item.bundleName, item.abilityName) && !item.appLabelId) {
      log.showWarn(`appLabelId invalid and get it now. cardId: ${item.cardId}, bundleName: ${item.bundleName}, ` +
        `appLabelId: ${item.appLabelId}`);
      item.appLabelId = await launcherAbilityManager.getAppLabelId(item.bundleName);
    }

    log.showWarn('appLabelId: %{public}d, bundleName: %{public}s, moduleName: %{public}s.', item.appLabelId,
      item.bundleName, item.moduleName);

    // 将系统替换场景的SceneBoard占位卡片名称替换为设备应用名称
    if (FormRelationManager.getInstance().isSceneBoardCard(item.bundleName, item.cardName)) {
      let appName: string = FormRelationManager.getInstance().getAppNameByCardId(item.cardId);
      if (!CheckEmptyUtils.checkStrIsEmpty(appName)) {
        log.showInfo(`set appName : ${appName}`);
        this.appNameLoadCallback(appName, item);
      }
    } else {
      // 语音助手建议无图标但是label不是固定需要特殊处理
      if (item.bundleName !== FormConstants.AI_SUGGESTION_BUNDLE_NAME &&
        NoIconAppModel.getInstance().checkIfBundleIsNoIconApp(item.bundleName)) {
        let appName: string = item.bundleName === CommonConstants.SCENEBOARD_BUNDLE ?
          ResourceManager.getInstance().getStringByName('lock_screen') :
          NoIconAppModel.getInstance().updateNoIconAppInfo(item.bundleName).label;
        this.appNameLoadCallback(appName, item);
        return;
      }
      this.mEvent.getAppName(item, (name: string) => {
        this.appNameLoadCallback(name, item);
      });
    }
  }

  private onLockReceived(): void {
    log.showInfo(`receive msg, lockReceived: ${this.mLockReceived}.`);
    this.showFormStackBackplaneAnimate(false);
  }

  //注册外屏菜单关闭事件
  private mOuterMenuCloseListener?: ReceiveEventInfo;

  private registerOuterMenuCloseListener(): void {
    this.mOuterMenuCloseListener = {
      onReceiveEvent: (event: string, params: string): void => {
        log.showInfo(`localEventListener receive event: ${event}, params: ${params}.`);
        if (event === EventConstants.EVENT_REQUEST_OUTER_MENU_CLOSE && params === this.mFormStackItem.formStackId) {
          this.isMenuAppear = false;
        }
      }
    };
    localEventManager.registerEventListener(this.mOuterMenuCloseListener, [
      EventConstants.EVENT_REQUEST_OUTER_MENU_CLOSE
    ]);
    log.showInfo('register Outer Stack Menu Close Listener');
  }

  //注册外屏菜单展开堆叠事件
  private mOuterMenuExpandListener?: ReceiveEventInfo;

  private registerOuterMenuExpandListener(): void {
    this.mOuterMenuExpandListener = {
      onReceiveEvent: (event: string, params: string): void => {
        log.showInfo(`localEventListener receive event: ${event}, params: ${params}.`);
        if (event === EventConstants.EVENT_REQUEST_OUTER_STACK_EXPAND && params === this.mFormStackItem.formStackId) {
          log.showInfo(`outer stack: ${this.mFormStackItem.formStackId} is expanding.`);
          this.openFormStack(true);
        }
      }
    };
    localEventManager.registerEventListener(this.mOuterMenuExpandListener, [
      EventConstants.EVENT_REQUEST_OUTER_STACK_EXPAND
    ]);
    log.showInfo('register Outer Stack Menu Expand Listener');
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear start');
    // 记录堆叠卡片顺序信息
    this.updateCardOrder();
    FormCommonUtil.compareCacheAndRdb();
    this.mEvent.setDesktopStatus(this.isOuterDesktop);
    this.initBasicData();
    this.updateTopCardId();
    this.showTopCardName(this.mFormStackTopCardId);
    this.mFormStackMenuViewModel = new FormStackMenuViewModel(this.mFormStackItem);
    this.mEvent.initData(this.mFormStackItem, this.mFormItemList, this.mViewModel);
    this.mEvent.initEventMsg({
      coverdFormStack: (isShow: boolean) => this.onEventhubCoveredItemEvent(isShow),
      openFormStackByMenu: () => this.onEventhubOpenFormStackByMenu(),
      updateFormStack: (itemList: CardItemInfo[]) => this.updateFormList(itemList),
      dropStackCard: (cards: GridLayoutItemInfo[], dragResult: DesktopDragResult) =>
        this.onEventhubItemDropEvent(cards, dragResult),
      formStackDropEnd: () => {},
      showFormName: () => this.onEventhubShowFormName(),
      formNameAnimate: (cardId: string, isDisappear?: boolean, callback?: () => void) =>
      this.formNameAnimate(cardId, isDisappear, callback),
      clearDropAnimateParam: () => this.clearDropAddCardAnimateParam(),
      resetFormStack: () => this.resetStackFormStatus(),
    });
    this.initPressAnimParams();
    this.getDialogName();
    GlobalContext.getContext()?.eventHub.on(EventConstants.CHANGE_CURRENT_LAYOUT_CACHE_DATA, this.syncLayoutCache);
    if (this.isOuterDesktop) {
      GlobalContext.getContext()?.eventHub.on(FormStackConstants.EVENTHUB_OUTER_FORMSTACK_MENU_DRAG_END,
        this.onOuterMenuDragEnd);
      GlobalContext.getContext()?.eventHub.on(FormStackConstants.EVENTHUB_OUTER_FORMSTACK_MENU_DRAG_START,
        this.onOuterMenuDragStart);
      this.registerOuterMenuCloseListener();
      this.registerOuterMenuExpandListener()
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear start');
    if (!CheckEmptyUtils.isEmpty(this.mViewModel)) {
      this.mViewModel.resetData();
    }

    this.mEvent.resetData();
    this.mEvent.resetEventMsg();
    GlobalContext.getContext()?.eventHub.off(EventConstants.CHANGE_CURRENT_LAYOUT_CACHE_DATA, this.syncLayoutCache);
    if (this.isOuterDesktop) {
      GlobalContext.getContext()?.eventHub.off(FormStackConstants.EVENTHUB_OUTER_FORMSTACK_MENU_DRAG_END,
        this.onOuterMenuDragEnd);
      GlobalContext.getContext()?.eventHub.off(FormStackConstants.EVENTHUB_OUTER_FORMSTACK_MENU_DRAG_START,
        this.onOuterMenuDragStart);
      localEventManager.unregisterEventListener(this.mOuterMenuCloseListener);
      localEventManager.unregisterEventListener(this.mOuterMenuExpandListener);
    }
  }

  private async updateCardId(cardItem: CardItemInfo, newCardId: string): Promise<void> {
    if (CheckEmptyUtils.checkStrIsEmpty(newCardId)) {
      FormDFXUtil.reportBuildStackCardInvalidFormId(cardItem, this.mFormItemList);
    }
    let oldCardId: string = cardItem.cardId;
    await FormViewModel.getInstance(this.singleContext)
      .updateCardIdOfFormStack(this.mFormStackItem.formStackId ?? '', cardItem, newCardId, this.isOuterDesktop);
    if (FormStackUtil.isInvalidFormStackList(this.mFormItemList)) {
      log.showError(`update cardId: ${newCardId} failed, invalid form list!`);
      return;
    }

    // 卡片ID更新后，刷新卡片
    if (oldCardId !== newCardId) {
      let idx: number = this.getCardIdxInFormList(`${cardItem.bundleName}${cardItem.cardId}`);
      log.showWarn(`find card idx: ${idx}, update it now. oldCardId: ${oldCardId}, newCardId: ${newCardId}`);
      if (idx >= 0 && idx < this.mFormStackForeachList.length) {
        let item: FormStackAnimateItem =
          ObjectCopyUtil.deepClone(this.mFormStackForeachList[idx], new FormStackAnimateItem());
        item.formId = newCardId;
        item.idStr = `${FormStackConstants.FORM_STACK_ID_PREFIX}_${cardItem.bundleName}_${newCardId}`;
        this.mFormStackForeachList[idx] = item;
      }
    }

    this.syncFormStackLayout();
    const len: number = this.mFormItemList.length;
    if (cardItem.bundleName === this.mFormItemList[len - 1].bundleName) {
      this.updateTopCardId();
      this.showTopCardName(this.mFormItemList[len - 1].cardId);
    }
  }

  private deleteCard(cardId: string, item: FormStackAnimateItem, resultType: number, errorMsg?: string): void {
    FormDFXUtil.reportBuildStackCardError(this.getCardInfo(item), this.mFormItemList,
      resultType, errorMsg);
    if (!CheckEmptyUtils.checkStrIsEmpty(cardId)) {
      this.mFormStackViewModel.deleteCardsFromFormStack(this.mFormStackItem.formStackId,
        [cardId], true, this.isOuterDesktop);
    } else {
      this.mFormStackViewModel.delPreloadCardInFormStack(
        this.mFormStackItem.formStackId, this.getCardInfo(item), this.isOuterDesktop);
    }
  }

  private updateName(cardId: string, name: string): void {
    this.mEvent.updateAppName(cardId, name, this.menuName);
    if (cardId === this.mFormStackTopCardId) {
      this.menuName = name;
    }
  }

  private initBasicData(): void {
    this.mFormItemList.push(...this.mFormStackItem.layoutInfo[0]);
    this.mSlideAnimate.initAnimateParam(this.mFormItemList[0].cardDimension);
    this.mViewModel.mFormBorderRadius = this.mFormBorderRadius;
    this.mViewModel.mSizeRatio = this.mSizeRatio;
    this.mViewModel.mBehindFormRotateAngle =
      (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).behindFormRotateAngle;
    this.mViewModel.initAnimateInfo(String(this.mFormStackItem.formStackId), this.mFormItemList,
      this.mFormStackForeachList);
    this.mDefaultSlideDownThreshold =
      ResUtils.mm2vp(FormStackConstants.slideThresholdDistance.get(this.mFormItemList[0].cardDimension) as number);
    this.mOuterDefaultSlideDownThreshold =
      ResUtils.mm2vp(FormStackConstants.outerSlideThresholdDistance.get(this.mFormItemList[0].cardDimension) as number);
    this.mSlideUpThreshold = -this.mFormStackItemHeight *
      (FormStackConstants.slideUpThresholdRatio.get(this.mFormItemList[0].cardDimension) as number);
    this.mFixedOffsetY = -FormStackStyleConstants.BOTTOM_CARD_OFFSET;
    this.mCardSlideDownMaxDistance = this.mFormStackItemHeight * FormStackConstants.SLIDE_DOWN_MAX_TRANSLATE_Y_RATIO;
    this.mCardOpacityChangeSlideRatio =
      this.mFormStackItemHeight * FormStackConstants.SLIDE_DOWN_OPACITY_CHANGE_DISTANCE_RATIO;
    this.mCardOpacityChangeInterval = this.mCardSlideDownMaxDistance - this.mCardOpacityChangeSlideRatio;
    this.mFormStackBuilderId = FormStackUtil.getFormStackComponentId(this.mFormStackItem.formStackId) + '_column';
  }

  private onHoverEventHandler(isHover: boolean): void {
    HoverAnimationUtil.hoverEffect(isHover, false, (hoverScale: number) => {
      this.formItemHoverScale = { x: hoverScale, y: hoverScale };
    });
  }

  private getMenuAnimationToScale(cardDimension: number): number {
    return NumberConstants.CONSTANT_NUMBER_ONE;
  }

  private getContextMenu(): ContextMenuOptions {
    return {
      offset: { x: NumberConstants.CONSTANT_NUMBER_ZERO, y: NumberConstants.CONSTANT_NUMBER_EIGHT },
      placement: this.menuPlacement,
      backgroundBlurStyle: BlurStyle.NONE,
      preview: MenuPreviewMode.IMAGE,
      onWillAppear: () => {
        localEventManager.sendLocalEventSticky(
          EventConstants.EVENT_DESKTOP_MENU_EVENT, CommonConstants.SCALE_FACTOR_WHEN_MENU_SHOW);
      },
      onWillDisappear: () => {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_MENU_EVENT,
          NumberConstants.CONSTANT_NUMBER_ONE);
      },
      onDisappear: () => {
        this.onMenuDisappear();
      },
      onAppear: () => {
        this.onMenuAppear();
      },
      previewAnimationOptions: {
        scale: this.isOuterDesktop ? [NumberConstants.CONSTANT_NUMBER_ONE,
          this.getMenuAnimationToScale(this.mFormItemList[0]?.cardDimension)] :
          [StyleConstants.MENU_ANIMATION_FROM, StyleConstants.MENU_ANIMATION_TO],
        transition: this.isHiddenEffect ? TransitionEffect.asymmetric(
          TransitionEffect.opacity(0),
          TransitionEffect.IDENTITY.animation({ duration: 0 })) : undefined,
      },
      transition: this.isHiddenEffect ? TransitionEffect.asymmetric(
        TransitionEffect.opacity(0),
        TransitionEffect.IDENTITY.animation({ duration: 0 })) : undefined,
    };
  }

  private getBlendModeParam(): void {
    log.showInfo(`current getBlendModeParam, needblend: ${this.isNeedBlendMode}`);
    if (!this.isNeedBlendMode) {
      this.blendModeParam.value = null;
      this.blendModeParam.type = null;
      return;
    }
    this.blendModeParam.value = BLEND_MODE_SRC_OVER;
    this.blendModeParam.type = BlendApplyType.OFFSCREEN;
  }

  build() {
    RelativeContainer() {
      Column() {
        Stack({ alignContent: Alignment.Bottom }) {
          if (this.mIsFormStackBackgroundOpen) {
            FormStackBackboard({
              mFormStackItemWidth: this.mFormStackItemWidth,
              mFormStackItemHeight: this.mFormStackItemHeight,
              mFormBorderRadius: this.mFormBorderRadius,
              mFormBackboardScale: this.mFormBackboardScale,
              mFormBackboardRadiusOffset: this.mFormBackboardRadiusOffset,
              mFormBackboardOffset: this.mFormBackboardOffset,
            })
          }
          ForEach(this.mFormStackForeachList, (item: FormStackAnimateItem) => {
            FormStackItemView({
              mAnimateItem: item,
              mCardItem: this.getCardInfo(item),
              mFormStackItemWidth: this.mFormStackItemWidth,
              mFormStackItemHeight: this.mFormStackItemHeight,
              mIsOuterDesktop: this.isOuterDesktop,
              mFixedOffsetY: this.mFixedOffsetY,
              mFormBorderRadius: this.mFormBorderRadius,
              mFormStackId: this.mFormStackItem.formStackId,
              mFormStackTopCardId: this.mFormStackTopCardId,
              mEventCallback: {
                onDeleteCardId: (cardId: string, resultType: number, errorMsg?: string) => {
                  this.deleteCard(cardId, item, resultType, errorMsg);
                },
                onUpdateId: (card: CardItemInfo, id: string) => {
                  this.updateCardId(card, id);
                },
                onUpdateName: (cardId: string, name: string) => {
                  this.updateName(cardId, name);
                },
                onIsAllowChangeOpacity: () => {
                  return this.mAnimateState === SlideOperateType.DEFAULT_STATE;
                },
                onClearImages: () => {
                },
                onChildFormLoad: (cardId: string) => {
                },
              },
            })
          }, (item: FormStackAnimateItem) => item.idStr)

          ForEach(this.mViewModel.mMaskList, (item: FormStackAnimateItem, index: number) => {
            SecondFormMask({
              maskItem: this.mViewModel.mMaskList[index],
              mFormStackItemWidth: this.mFormStackItemWidth,
              mFormStackItemHeight: this.mFormStackItemHeight,
              mIsOuterDesktop: this.isOuterDesktop,
              mFixedOffsetY: this.mFixedOffsetY,
              mStaticMaskExtraWidth: this.mStaticMaskExtraWidth,
            })
          }, () => this.mViewModel.mMaskList.length.toString())

          if (this.mIsFormStackBackgroundOpen) {
            FormStackMask({
              mFormStackItemWidth: this.mFormStackItemWidth,
              mFormStackItemHeight: this.mFormStackItemHeight,
              mFormBorderRadius: this.mFormBorderRadius,
              mFormStackMaskOpacity: this.mFormStackMaskOpacity,
              mFormStackScale: this.mFormStackScale,
              mFormStackOffset: this.mFormStackOffset,
              mZIndex: this.mFormItemList.length * 2,
            })
          }
        }
        .bindContextMenu(this.showMenu && !this.isOuterDesktop, this.LongPressMenuBuilder, this.getContextMenu())
        .dragStyles()
        .hitTestBehavior(this.editModeState.isInEditMode() ? HitTestMode.None : HitTestMode.Default)
        .visibility(this.isFormStackHidden() ? Visibility.Hidden : Visibility.Visible)
        .height( this.mFormStackItemHeight + Math.abs(this.mFixedOffsetY))
        // 注意不能使用偏移属性进行布局调整，会导致组件真实坐标与显示位置不一致
        .margin({ top: this.mFixedOffsetY })
        .id(FormStackUtil.getFormStackComponentId(this.mFormStackItem.formStackId))
        .blendMode(this.isBlurAnimRunning.value ? BLEND_MODE_SRC_OVER : this.blendModeParam.value,
          this.isBlurAnimRunning.value ? BlendApplyType.OFFSCREEN : this.blendModeParam.type)
      }
      .id(this.mFormStackBuilderId)
      .opacity(this.isInDrag ? CommonConstants.FORM_HIDDEN_OPACITY : 1)
      .size({ width: this.mFormStackItemWidth, height: this.mFormStackItemHeight})
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        top: { anchor: '__container__', align: VerticalAlign.Top },
      })
      .onTouch((event: TouchEvent) => {
        this.handleTouchEvent(event);
      })
      .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
        return this.handleGestureJudge(gestureInfo);
      })
      .panGestureStyle()
      .longPressGestureStyle()
      .dragStyles()
      .accessibilityRole(AccessibilityRoleType.FORM_COMPONENT)
      .onHover((isHover: boolean) => { this.onHoverEventHandler(isHover); })
      .scale(this.formItemComponentScale)
      .accessibilityText(this.menuName)
      .accessibilityDescription(ResUtils.getInnerString($r('app.string.cc_accessibility_str_click')) +
        ResUtils.getInnerString($r('app.string.cc_accessibility_str_long_click')))
      .onClick(() => {
        // 编辑模式下卡片组件的hitTestBehavior为None,
        // 需要在这里捕获事件，防止冒泡到桌面触发桌面点击事件导致退出编辑模式
      })
      if (!this.isOuterDesktop) {
        this.appNameBuilder();
      }
    }
    .scale(this.formItemHoverScale)
  }

  @Builder
  appNameBuilder() {
    Stack() {
      FormAppName({
        formStackAppName: this.lastName,
        mOpacity: this.lastNameOpacity,
        mFormStackNameSize: this.mFormStackNameSize,
        mNameFontColor: this.mNameFontColor,
        mFormStackNameHeight: this.mFormStackNameHeight,
        mFormStackNameWidth: this.mFormStackNameWidth,
        mNameLines: this.mNameLines,
        mIconNameMargin: this.mIconNameMargin,
        marginLeft: this.marginLeft,
        getIndexInSwiper: this.getIndexInSwiper,
        colStart: this.mFormStackItem.column,
        colEnd: this.calculateColEnd(this.mFormStackItem),
        rowEnd: this.calculateRowEnd(this.mFormStackItem),
        parentItem: this.mFormStackItem
      })
      FormAppName({
        formStackAppName: this.nextName,
        mOpacity: this.nextNameOpacity,
        mFormStackNameSize: this.mFormStackNameSize,
        mNameFontColor: this.mNameFontColor,
        mFormStackNameHeight: this.mFormStackNameHeight,
        mFormStackNameWidth: this.mFormStackNameWidth,
        mNameLines: this.mNameLines,
        mIconNameMargin: this.mIconNameMargin,
        marginLeft: this.marginLeft,
        getIndexInSwiper: this.getIndexInSwiper,
        colStart: this.mFormStackItem.column,
        colEnd: this.calculateColEnd(this.mFormStackItem),
        rowEnd: this.calculateRowEnd(this.mFormStackItem),
        parentItem: this.mFormStackItem
      })
    }
    .alignRules({
      top: { anchor: this.mFormStackBuilderId, align: VerticalAlign.Bottom },
      middle: { anchor: this.mFormStackBuilderId, align: HorizontalAlign.Center }
    })
    .opacity(this.formNameOpacity)
    .zIndex(-2)
    .margin({ top: this.mIconNameMarginTop })
  }

  private calculateColEnd(formItem?: FormStackItemInfo): number {
    if (formItem && formItem.column !== undefined && formItem.column >= 0 &&
      CheckEmptyUtils.isEmptyArr(formItem.area)) {
      return formItem.column + formItem.area[0] - 1;
    }
    log.showError(`calculateColEnd formStackItem invalid, column=${formItem?.column}, areaLength=${formItem?.area?.length}`);
    return 0;
  }

  private calculateRowEnd(formItem?: FormStackItemInfo): number {
    if (formItem && formItem.row !== undefined && formItem.row >= 0 && CheckEmptyUtils.isEmptyArr(formItem.area)) {
      return formItem.row + formItem.area[1] - 1;
    }
    log.showError(`calculateRowEnd formStackItem invalid, row=${formItem?.row}, areaLength=${formItem?.area?.length}`);
    return 0;
  }

  private onEventhubShowFormName(): void {
    if (this.isAnimateListInvalid()) {
      return;
    }

    log.showInfo('show form stack name when closing edit');
    if (this.isListChangeByEdit) {
      this.updateTopCardId();
      this.mEvent.syncFormItemList(this.mFormItemList);
    }

    if (!this.isToOpenFormStack) {
      this.isListChangeByEdit = false;
    }
    this.showTopCardName(this.mFormStackTopCardId);
    // 堆叠收起，名称恢复显示
    if (this.isLast) {
      this.lastNameOpacity = 1;
    } else {
      this.nextNameOpacity = 1;
    }
  }

  // 本地数据同步缓存
  private syncLayoutCache: () => void = () => {
    const cache: FormStackItemInfo = FormLayoutCacheManager.getInstance().selectGridLayoutItemByFormstackId(
      this.mFormStackItem.formStackId) as Object as FormStackItemInfo;
    if (cache) {
      cache.layoutInfo[0] = [...this.mFormItemList];
    }
  }

  private updateFormList(cards: CardItemInfo[]): void {
    log.showInfo('form stack layout info changed');
    if (CheckEmptyUtils.isEmptyArr(cards)) {
      return;
    }

    this.mFormItemList = [...cards];
    log.showWarn(`update cardIds = ${this.mFormItemList.map(i => i.cardId)}`);
    this.mFormStackItem.layoutInfo[0] = [...cards];
    this.updateCardOrder();
    // 同步更新缓存
    const cache: FormStackItemInfo = FormLayoutCacheManager.getInstance().selectGridLayoutItemByFormstackId(
      this.mFormStackItem.formStackId) as Object as FormStackItemInfo;
    if (cache) {
      cache.layoutInfo[0] = [...cards];
    }
    this.updateTopCardId();

    this.isListChangeByEdit = true;
  }

  private onEventhubOpenFormStackByMenu(): void {
    log.showInfo('recv msg to expand formstack by menu.');
    this.isToOpenFormStack = true;
  }

  private onEventhubItemDropEvent(dragItemInfos: GridLayoutItemInfo[], dragResult: DesktopDragResult): void {
    log.showInfo('showFormDropAnimate start');
    // 注册落位动效结束回调
    const dropAniListener: DropAnimationListener = {
      onDropAnimationEnd: (a: DropAnimationDestination, b: DropAnimationParam, c: boolean, isCancel: boolean) => {
        // 清除监听动画结束事件
        dropAnimationObserver.unregisterDropAnimationListener(dropAniListener);
        // 打断落位动效需要更新快照
        this.needUpdateDragSnapShot = true;
        this.formNameOpacity = 1;
        // 恢复formNameOpacity、需要清空原来显示的名称、否则会出现两个名称
        if (this.isLast) {
          this.lastName = '';
        } else {
          this.nextName = '';
        }
        const addCardsMsgId: string =
          FormStackEventIdUtil.getAddCardsToFormStackEventId(this.mFormStackItem.formStackId);
        GlobalContext.getContext()?.eventHub.emit(addCardsMsgId, dragItemInfos);
        // 刷新布局
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      }
    }
    dropAnimationObserver.registerDropAnimationListener(dropAniListener);
    dragResult.parallelAnimation = () => this.dropAnimation();
  }

  private dropAnimation: () => void = () => {
    //背板动效
    this.mFormBackboardScale = 1;
    this.mFormBackboardRadiusOffset = 0;
    this.mFormBackboardOffset = 0;
    // 蒙版透明度渐变和缩放
    this.mFormStackMaskOpacity = 0.9;
    this.mViewModel.onDropMoveDown(Math.abs(this.mFixedOffsetY));
  }

  private onEventhubCoveredItemEvent(isShow: boolean): void {
    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    if ((dragItemType === CommonConstants.DRAG_FROM_DESKTOP || dragItemType === CommonConstants.DRAG_FROM_APP_ICON ||
      CommonConstants.DRAG_FROM_DOCK || CommonConstants.DRAG_FROM_MANAGE || CommonConstants.DRAG_FROM_FORM_SERVICE) &&
      FormStackViewModel.isSupportFormStack()) {
      log.showInfo(`onEventhubCoveredItemEvent item:${this.mFormStackItem.formStackId}, isShow:${isShow}`);
      // 手动清空blendModeParam、防止被截断
      this.blendModeParam.value = null;
      this.blendModeParam.type = null;
      this.showFormStackBackplaneAnimate(isShow);
    }
  }

  private showFormStackBackplaneAnimate(isBackplaneOpen: boolean): void {
    if (!this.mIsFormStackBackgroundOpen && !isBackplaneOpen) {
      log.showInfo('backplane disappeared, no action required.');
      return;
    }

    if (this.mFormStackItemWidth !== 0 && this.mFormStackItemWidth !== undefined) {
      let formBackboardRatio: number =
        (this.mFormStackItemWidth + StyleConstants.CARD_BACKGROUND_SIZE_OFFSET) / this.mFormStackItemWidth;
      this.mFormBackboardOffsetY =
        this.mFormStackItemHeight * (formBackboardRatio - 1) / 2 - FormStackStyleConstants.BOTTOM_CARD_OFFSET;
    }
    if (isBackplaneOpen) {
      log.showInfo('showAppBackplaneAnimate start');
      this.mIsFormStackBackgroundOpen = true;
      animateTo({
        curve: curves.springMotion(0.45, 1),
      }, () => {
        // 背板缩放
        this.mFormBackboardScale = 2 - this.mSizeRatio;
        this.mFormBackboardRadiusOffset = StyleConstants.CARD_BACKGROUND_SIDE_OFFSET;
        this.mFormBackboardOffset = -(this.mFixedOffsetY + this.mFormBackboardOffsetY);
        // 蒙版透明度渐变和缩放
        this.mFormStackMaskOpacity = 0.1;
        // 卡片缩放位移
        this.mFormStackScale = this.mSizeRatio;
        this.mFormStackOffset = this.mFixedOffsetY;
        this.mViewModel.dragAnimateZoom(false, this.mSizeRatio, this.mFixedOffsetY);
        // 背板出现，隐去卡片堆叠的名字
        this.formNameOpacity = 0;
      })
    } else {
      log.showInfo('showAppBackplaneAnimate end');
      animateTo({
        curve: curves.springMotion(0.45, 1),
      }, () => {
        this.mIsFormStackBackgroundOpen = false;
        // 背板缩放
        this.mFormBackboardScale = 1;
        this.mFormBackboardRadiusOffset = 0;
        this.mFormBackboardOffset = 0;
        // 蒙版透明度渐变和缩放
        this.mFormStackMaskOpacity = 0;
        // 卡片缩放
        this.mFormStackScale = 1;
        this.mFormStackOffset = 0;
        // 背板消失，显示卡片堆叠的名字
        this.formNameOpacity = 1;
        // 背板缩放
        this.mViewModel.dragAnimateZoom(true, this.mSizeRatio, 0);
      })
    }
  }

  private cancelLongPressAnimation(): void {
    log.showInfo('cancelLongPressAnimation animation cancel');
    animateTo({
      duration: 0,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      onFinish: () => {
        this.formItemComponentScale = { x: StyleConstants.DEFAULT_1, y: StyleConstants.DEFAULT_1 };
        GlobalContext.getContext()?.eventHub.off(`otherIconLongPressEffectCancel`,
          this.otherIconLongPressEffectCancelFunc);
      }
    }, () => {
      this.formItemComponentScale =
        { x: StyleConstants.CANCEL_LONG_PRESS_SCALE, y: StyleConstants.CANCEL_LONG_PRESS_SCALE };
    })
  }

  @Styles
  panGestureStyle() {
    .gesture(
      PanGesture({ fingers: 1, direction: PanDirection.Vertical,
        distance: FormStackConstants.SLIDE_GESTURE_MIN_VALID_DISTANCE })
        .onActionStart((event: GestureEvent) => {
          if (this.isMenuAppear) {
            return;
          }
          this.panGestureActionStart(event);
        })
        .onActionUpdate((event: GestureEvent) => {
          if (this.isMenuAppear) {
            return;
          }
          this.panGestureActionUpdate(event);
        })
        .onActionEnd((event: GestureEvent) => {
          if (this.isMenuAppear) {
            return;
          }
          this.panGestureActionEnd(event);
        })
        .onActionCancel(() => {
          if (this.isMenuAppear) {
            return;
          }
          this.panGestureActionCancel();
        })
    )
  }

  @Styles
  longPressGestureStyle() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        // 100ms 空长按手势确保图标优先于编辑模式背板响应长按手势
        LongPressGesture({ repeat: false, duration: EditModeConstants.PAGE_DRAG_SKIP_GESTURE_TIME})
          .onAction(() => {
            GlobalContext.getContext()?.eventHub.emit(`mFormStackPressTypeChange_${this.mFormStackTopCardId}`,
              LongPressType.GET_WALLPAPER);
        }),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_VIBRATOR_TIME })
          .onAction(() => {
            if (lockLayoutManager.isLockLayout()) {
              lockLayoutManager.toastLockedLayout();
            }
            let lastFormStackItem: FormStackAnimateItem | undefined =
              this.mFormStackForeachList[this.mFormStackForeachList.length - 1];
            if (!lastFormStackItem || lastFormStackItem.mOpacity < 1) {
              // 堆叠最上面没有卡片或者透明度没恢复，不显示菜单，否则会显示透明卡片
              return;
            }
            if (!scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
              FormStackUtil.playVibration();
              if (this.isOuterDesktop && !editModeManager.isInEditMode()) {
                // 更新下拖拽预览截图
                if (this.needUpdateDragSnapShot) {
                  this.updateDragSnapShot();
                }
                FormStackDataAdapt.getInstance().handleMsg<FormStackItemInfo>(
                  FormStackMsg.SET_FORM_STACK_OUTER_MENU, this.mFormStackItem);
                this.isMenuAppear = true;
              }
            }
            // 拖拽适配无障碍朗读堆叠卡片起拖播报
            DragAccessibilityUtils.textAnnouncedForDragStart();
            if (ScreenSplitUtil.isScreenSplit(TAG)) {
              return;
            }
            if (!editModeManager.isInEditMode() && !AppStorage.get<boolean>('isDrag')) {
              this.showMenu = true;
            }
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.CONSTANT_NUMBER_550 })
          .onAction(() => {
            log.showInfo('long press reach max.');
            if (editModeManager.isInEditMode()) {
              this.playLongPressAnimation(false, StyleConstants.EDIT_MODE_LONG_PRESS_SCALE);
            }
          }),
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_ZOOM_IN_WITH_MENU })
          .onAction(() => {
            GlobalContext.getContext()?.eventHub.emit('appIconLongPressEffectCancel', true);
            if (!editModeManager.isInEditMode()) {
              this.playLongPressAnimation(false);
            }
            GlobalContext.getContext()?.eventHub.emit(`mFormStackPressTypeChange_${this.mFormStackTopCardId}`,
              LongPressType.SHOW_WALLPAPER);
          }),
        LongPressGesture({ repeat: false, duration: FormStackConstants.FORMSTACK_LONG_PRESS_SNAP_IAMGE_TIME })
          .onAction(() => {
            if (!editModeManager.isInEditMode() && !AppStorage.get<boolean>('isDrag')) {
              this.mCoverFormItem = this.mEvent.getFormIfNeedCover();
              GlobalContext.getContext()?.eventHub.emit(`mFormStackPressTypeChange_${this.mFormStackTopCardId}`,
                LongPressType.SELECTED_ITEM);
              log.showInfo(`top form: ${this.mFormStackTopCardId}, set cover form: ${this.mCoverFormItem?.cardId}`);
            }
          }),
        LongPressGesture({ repeat: false, duration: AiSuggestionConstants.LONG_PRESS_SELECT_ITEM_SNAP_DURATION })
          .onAction(() => {
            if (AiSuggestionUtil.isVoiceAbilityForm(this.mCurrentFormItem.bundleName,
              this.mCurrentFormItem.abilityName)) {
              this.getFormStackSnapshot();
            }
          }),
      )
    )
  }

  @Builder
  dragIconBuilder() {
    Image(this.dragSnapshot)
      .draggable(false)
      .width(EditModeUtils.convertWithDesktopScale(this.mFormStackItemWidth))
      .height(EditModeUtils.convertWithDesktopScale(
        this.mFormStackItemHeight + Math.abs(this.mFixedOffsetY)))
      .syncLoad(true)
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
  }

  @Styles
  dragStyles() {
    .onDragStart((event: DragEvent) => {
      log.showWarn('form stack drag start');
      this.isDragging = true;
      this.showMenu = false;
      this.resetFormStackOfMisSlide();
      // 更新下拖拽预览截图
      if (this.needUpdateDragSnapShot) {
        this.updateDragSnapShot();
      }
      return this.mDragStartFun?.(event);
    })
    .onDragEnd((event: DragEvent, extraParams: string) => {
      log.showWarn(`formStack onDragEnd position: [${event.getX()}, ${event.getY()}], result: ${event.getResult()}`);
      AppStorage.setOrCreate<boolean>('isDrag', false);
      DragEventManager.getInstance().startDrop(
        GridLayoutUtil.generateUniqueKey(this.mFormStackItem as Object as GridLayoutItemInfo));
      AppStorage.setOrCreate<Object>('dragItemInfo', {});
      // 拖拽不回调touch up事件，需要在dragEnd中释放
      this.isFormStackTouch = false;
      this.isDragging = false;
      this.playLongPressAnimation(false);
      if (this.isMenuAppear) {
        this.isMenuAppear = false;
      }
      if (this.isOuterDesktop) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_OUTER_STACK_DRAG_END,
          this.mFormStackItem.formStackId);
      }
      return false;
    })
    .dragPreviewOptions({
      mode: DragPreviewMode.DISABLE_SCALE,
      modifier: new ImageModifier().borderRadius(this.mFormBorderRadius)
    }, {
      // isDragPreviewEnabled: false
    })
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      return this.mEvent.onGestureJudgeBegin(gestureInfo, event);
    })
  }

  private onMenuAppear(): void {
    log.showInfo('menu onAppear.');
    this.isMenuAppear = true;
  }

  private onMenuDisappear(): void {
    log.showInfo('menu onDisappear.');
    this.showMenu = false;
    this.isMenuAppear = false;
    this.isHiddenEffect = false;
    GlobalContext.getContext()?.eventHub.emit(`mFormStackPressTypeChange_${this.mFormStackTopCardId}`,
      LongPressType.DEFAULT);
    // appName 渐显
    animateTo({
      duration: 100,
      curve: Curve.Linear,
    }, () => {
      this.formNameOpacity = 0.99;
    })
    if (this.isToOpenFormStack) {
      this.openFormStack(true);
    } else {
      this.mEvent.emitMenuDisappearMsg();
    }
  }

  private isAnimateListInvalid(): boolean {
    return CheckEmptyUtils.isEmpty(this.mViewModel) || CheckEmptyUtils.isEmptyArr(this.mViewModel.mItemInfoList) ||
      CheckEmptyUtils.isEmptyArr(this.mViewModel.mMaskList) || CheckEmptyUtils.isEmptyArr(this.mFormItemList);
  }

  /**
   * 场景一：先触发滑动，再触发拖拽，后续滑动需要响应，保证滑动状态可以重置
   * 场景二：先触发拖拽，再触发滑动，滑动事件默认不响应
   * @returns 是否响应滑动手势
   */
  private isGestureForbidden(): boolean {
    return this.isDragging && this.mSlideStartTime === 0;
  }

  private handleTouchEvent(event: TouchEvent): void {
    if (!event) {
      log.showError('formstack touch event invalid!');
      return;
    }

    if (event.type !== TouchType.Down && event.type !== TouchType.Up && event.type !== TouchType.Cancel) {
      return;
    }

    if (scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK) && !this.isFormStackTouch) {
      log.showWarn('formstack touch in exclusive scene!');
      return;
    }

    log.showWarn(`formstack touch type: ${event.type}`);
    this.dealTouchStatus(event.type);
    if (this.isMenuAppear || this.isAnimateListInvalid()) {
      log.showWarn('menu appear or animate list empty!');
      return;
    }
    if (event.type === TouchType.Down) {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
      this.mSlideStartTime = 0;
      // 每次操作前确保堆叠状态重置
      this.resetAnimateStatusByTouch();
      this.setAppMenuPosition(event);
      GlobalContext.getContext()?.eventHub.off(`otherIconLongPressEffectCancel`, this.otherIconLongPressEffectCancelFunc);
      GlobalContext.getContext()?.eventHub.on(`otherIconLongPressEffectCancel`, this.otherIconLongPressEffectCancelFunc);
      this.playLongPressAnimation(true);
    } else {
      GlobalContext.getContext()?.eventHub.off(`otherIconLongPressEffectCancel`, this.otherIconLongPressEffectCancelFunc);
      this.playLongPressAnimation(false);
    }
  }

  private openFormStackFlagChange(): void {
    if (!this.isFormStackIdMatch() || this.isAnimateListInvalid()) {
      return;
    }
    log.showWarn(`openFormStackFlag change to: ${this.openFormStackFlag}`);
    if (!this.openFormStackFlag) {
      this.isToOpenFormStack = false;
      GlobalContext.getContext()?.eventHub.emit(`mFormStackPressTypeChange_${this.mFormStackTopCardId}`,
        LongPressType.DEFAULT);
      AppStorage.setOrCreate('dragCardOfFormstackClosed', true);
      if (this.isListChangeByEdit) {
        this.mViewModel.updateFormListByClose(this.mFormItemList);
      }
      this.isListChangeByEdit = false;
      FormStackManager.getInstance().clearFormStackId();
      FormStackManager.getInstance().clearTopFormId();
      // 无障碍模式下，回到桌面时，桌面堆叠获焦
      if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
        AccessibilityManager.getInstance().requestFocusAccessibility(this.mFormStackBuilderId);
      }
    }
  }

  private actionParamInvalid(event: GestureEvent): boolean {
    return CheckEmptyUtils.isEmpty(event) ||
      CheckEmptyUtils.isEmptyArr(event.fingerList) ||
      CheckEmptyUtils.isEmpty(event.fingerList[0]) ||
      this.isAnimateListInvalid();
  }

  private panGestureActionStart(event: GestureEvent): void {
    log.showWarn('onActionStart');
    if (!event || this.isAnimateListInvalid() || this.isDragging) {
      log.showError('onActionStart event is null');
      return;
    }
    if (!this.displayInfo) {
      log.showError('displayInfo is empty');
      return;
    }
    // 手动清空blendModeParam、防止被截断
    this.blendModeParam.value = null;
    this.blendModeParam.type = null;
    // 滑动开始后默认禁用卡片点击，滑动结束后解禁
    this.mEvent.onDisableFormClick();
    TraceUtil.traceOnce(DomainName.SCB, TraceUtil.CORE_METHOD_FS_SLIDE_START);
    const downPoint: number = event.fingerList?.[0]?.globalY as number;
    // downPoint 不能超过堆叠的底部
    const centerY: number = GridLayoutUtil.getIconCenterPosition(this.mFormStackItem.row,
      this.mFormStackItem.column, this.mFormStackItem.area)[1] || Number.MAX_SAFE_INTEGER;
    const fingerToScreenBottom: number =
      px2vp(this.displayInfo.height) - Math.min(this.mFormStackItemHeight / 2 + centerY, downPoint) -
      ResUtils.mm2vp(this.isOuterDesktop ? 0 : FormStackConstants.SLIDE_TO_SCREEN_BOTTOM_DISTANCE);
    this.mSlideDownThreshold = this.isOuterDesktop ?
      Math.min(fingerToScreenBottom, this.mOuterDefaultSlideDownThreshold) :
      Math.min(fingerToScreenBottom, this.mDefaultSlideDownThreshold);
    log.showInfo('fingerToScreenBottom: %{public}d, mSlideDownThreshold: %{public}d.',
      fingerToScreenBottom, this.mSlideDownThreshold);

    this.mSlideStartTime = event.timestamp;
    this.slideMoveY = event.offsetY;
    this.lastMoveY = event.offsetY;
    this.slideInitData(event.offsetY);
    if (event.offsetY <= 0) {
      this.maskDownshiftAnimate(true);
    }
    if (this.mFormItemList.length === 2) {
      // 截图
      const cardId = FormStackUtil.getFormComponentId(this.mFormItemList[1])
      componentSnapshot.get(cardId)?.then((pixmap: image.PixelMap) => {
        this.topCardSnapshot = pixmap;
      }).catch((error: BusinessError) => {
        log.showError(`snap image of componentId: ${cardId} failed, error: ${error?.code}!`);
      });
    }
    SCBTransitionManager.getInstance().cancelCloseAppAnimate();
    performanceMonitor.begin(FormStackConstants.SLIDE_TO_SWITCH_CARD_DOT, performanceMonitor.ActionType.FIRST_MOVE);
  }

  private panGestureActionUpdate(event: GestureEvent): void {
    if (this.actionParamInvalid(event) || this.isDragging ||
      Math.abs(event.offsetY) < FormStackConstants.SLIDE_GESTURE_MIN_VALID_DISTANCE) {
      log.showWarn('action update param is invalid or no response required');
      return;
    }

    if (this.isToOpenFormStack) {
      return;
    }

    TraceUtil.traceOnce(DomainName.SCB, TraceUtil.CORE_METHOD_FS_SLIDE_UPDATE);
    this.slideMoveY = event.offsetY;
    if (this.lastMoveY !== 0 && (this.slideMoveY / this.lastMoveY < 0)) {
      // 反方向滑动
      log.showWarn('sliding to the opposite direction');
      this.restoreFormParam(false);
      this.slideInitData(this.slideMoveY);
      this.maskDownshiftAnimate(this.slideMoveY <= 0, this.slideMoveY > 0);
      this.lastMoveY = this.slideMoveY;
    }

    this.slideMoveAnimate(this.slideMoveY);
  }

  private panGestureActionEnd(event: GestureEvent): void {
    if (this.mFormItemList.length === 2) {
      Promise.resolve().then(() => {
        this.topCardSnapshot?.release();
        this.topCardSnapshot = null;
      })
    }
    if (!event || this.isAnimateListInvalid() || this.isGestureForbidden()) {
      log.showError('action end param is invalid or no response required');
      return;
    }

    log.showWarn(`gesture end, offSetY: ${event.offsetY}.`);
    if (this.openFormStackFlag || this.isToOpenFormStack) {
      log.showInfo('form stack opening, no response required');
      return;
    }
    if (this.mSlideCount < 0) {
      this.mSlideCount = 0;
    }
    this.mSlideCount++;
    log.showInfo(`slide count plus one: ${this.mSlideCount}`);
    let slideDuration: number = (event.timestamp as number - this.mSlideStartTime) / Math.pow(10, 9);
    this.mSlideStartTime = 0;
    if (slideDuration <= 0 || this.isDragging) {
      log.showWarn('gesture action error or inadvertent touch, go to restore');
      this.slideBackAnimate();
      return;
    }
    let speed = Math.abs(event.offsetY / slideDuration);
    if (this.isSlideUpSuccessful(event, speed)) {
      log.showWarn('slide up form start');
      this.slideUpAnimate();
      return;
    }
    if (this.isSlideDownSuccessful(event, speed) || this.isEditModeSlideDownSuccessful(event, speed)) {
      log.showWarn('slide down form start');
      this.slideDownAnimate();
      return;
    }
    // 滑动失败
    log.showWarn('slide down form back');
    this.slideBackAnimate();
  }

  private panGestureActionCancel(): void {
    if (this.isAnimateListInvalid() || this.isGestureForbidden()) {
      log.showError('formstack animate params invalid, action cancel do not response!');
      return;
    }

    log.showWarn('gesture cancel, restore formstack.');
    if (this.openFormStackFlag || this.isToOpenFormStack) {
      log.showInfo('form stack opening, no response required');
      return;
    }
    if (this.mSlideCount < 0) {
      this.mSlideCount = 0;
    }
    this.mSlideCount++;
    this.mSlideStartTime = 0;
    log.showInfo(`slide count plus one: ${this.mSlideCount}`);
    // 滑动事件被取消，还原堆叠卡片状态
    this.slideBackAnimate();
  }

  /**
   * 是否上滑翻页成功
   * @param event
   * @param speed
   * @returns
   */
  private isSlideUpSuccessful(event: GestureEvent, speed: number): boolean {
    return event.offsetY < 0 && (speed >= px2vp(FormStackStyleConstants.SLIDE_NEXT_PAGE_VELOCITY_THRESHOLD) ||
      event.offsetY < FormStackConstants.SLIDE_UP_SUCCESS_FORM_TRANSLATE_THRESHOLD_RATIO * this.mSlideUpThreshold);
  }

  /**
   * 是否下滑翻页成功
   * @param event
   * @param speed
   * @returns
   */
  private isSlideDownSuccessful(event: GestureEvent, speed: number): boolean {
    return event.offsetY >= 0 && speed >= px2vp(FormStackStyleConstants.SLIDE_NEXT_PAGE_VELOCITY_THRESHOLD);
  }

  /**
   * 编辑模式增加一种下滑翻页成功条件(下滑翻页的距离阈值与上滑保持一致)
   * @param event
   * @param speed
   * @returns
   */
  private isEditModeSlideDownSuccessful(event: GestureEvent, speed: number): boolean {
    return event.offsetY >= 0 && speed < px2vp(FormStackStyleConstants.SLIDE_NEXT_PAGE_VELOCITY_THRESHOLD) &&
      editModeManager.isInEditMode() &&
      event.offsetY > FormStackConstants.SLIDE_UP_SUCCESS_FORM_TRANSLATE_THRESHOLD_RATIO * (-this.mSlideUpThreshold);
  }

  private switchBottomCardToTop(): void {
    log.showInfo('switch bottom card to top.');
    this.mFormItemList.push(this.mFormItemList[0]);
    this.mFormItemList.shift();
    this.updateTopCardId();
    this.updateAccessibilityFocus(this.mFormStackBuilderId);
    this.syncFormStackLayout();
    log.showWarn(`cardIds = ${this.mFormItemList.map(i => i.cardId)}`);
  }

  private switchNextCardToTop(): void {
    log.showInfo('switch next card to top.');
    this.mFormItemList.unshift(this.mFormItemList[this.mFormItemList.length - 1]);
    this.mFormItemList.pop();
    this.updateTopCardId();
    this.updateAccessibilityFocus(this.mFormStackBuilderId);
    this.syncFormStackLayout();
    log.showWarn(`cardIds = ${this.mFormItemList.map(i => i.cardId)}`);
  }

  private updateAccessibilityFocus(comId: string): void {
    if (!AccessibilityManager.getInstance().getIsAccessibilityMode() || CheckEmptyUtils.checkStrIsEmpty(comId)) {
      return;
    }
    // 无障碍模式下，非展开态切换卡片时，顶部卡片主动获焦
    AccessibilityManager.getInstance().requestFocusAccessibility(comId);
  }

  private updateAccessibilityFocusWhenDelete(): void {
    if (!AccessibilityManager.getInstance().getIsAccessibilityMode()) {
      return;
    }

    // 播报卡片删除
    let deleteItem: FormStackAnimateItem | undefined =
      this.mFormStackForeachList[this.mFormStackForeachList.length - 1];
    let deleteCardInfo: CardItemInfo | undefined = this.getCardInfo(deleteItem);
    let deleteCardName: string = ResourceManager.getInstance()
      .getCachedAppName(deleteCardInfo?.appLabelId, deleteCardInfo?.bundleName, deleteCardInfo?.moduleName);
    let deleteFormText: string = ResUtils.getInnerStringNumS($r('app.string.delete_stack_form'), `${deleteCardName}`);
    AccessibilityManager.getInstance().sendTextAnnouncedForAccessibility(deleteFormText, 'textAnnouncedForDeleteStack');

    if (this.mFormStackForeachList.length > 2) {
      return;
    }

    let lastItem: FormStackAnimateItem = this.mFormStackForeachList[0];
    let comId: string = `${CommonConstants.SWIPER_FORM_TAG}${lastItem.bundleName}_${lastItem.formId}`;
    setTimeout(() => AccessibilityManager.getInstance().requestFocusAccessibility(comId), 400);
  }

  @Builder
  LongPressMenuBuilder() {
    FormStackMenu({
      cardMenuInfoList: this.mFormStackMenuViewModel?.getFormMenuInFormStack(this.mCurrentFormItem,
        this.mCoverFormItem, this.menuName, this.deleteFormStackFunc),
      formStackMenuInfoList: this.formStackMenuInfoList,
      closeMenu: () => this.closeMenu(),
      menuPlacement: this.menuPlacement,
      isOuterDesktop: this.isOuterDesktop
    })
      .backgroundColor(SCBConstants.DEFAULT_SCENE_BG_COLOR)
      .width(StyleConstants.FORM_MENU_WIDTH)
      .onAppear(() => {
        log.showInfo('MenuBuilder onAppear');
        this.isMenuAppear = true;
        this.isMenuClicked = false;
        GlobalContext.getContext()?.eventHub.emit('AIBarShow', true);
        MenuInfoManager.getInstance()
          .getContextMenuListener(this.mCurrentFormItem?.cardId)?.onMenuAppear?.(ResponseType.LongPress);
        // appName 隐藏
        animateTo({
          duration: 100,
          curve: Curve.Linear,
        }, () => {
          this.formNameOpacity = 0.01;
        })
      })
      .onDisAppear(() => {
        log.showInfo('MenuBuilder onDisAppear');
        this.isMenuAppear = false;
        GlobalContext.getContext()?.eventHub.emit('AIBarShow', false);
        const isClicked: boolean = this.isMenuClicked;
        this.isMenuClicked = false;
        this.reportShortcutMenuClicked(isClicked);
        MenuInfoManager.getInstance()
          .getContextMenuListener(this.mCurrentFormItem?.cardId)?.onMenuDisappear?.(ResponseType.LongPress);
      })
  }

  private closeMenu(): void {
    this.isMenuClicked = true;
  }

  private reportShortcutMenuClicked(isClicked: boolean): void {
    if (isClicked !== false) {
      return;
    }
    const cardItemInfo: CardItemInfo = this.mFormItemList[this.mFormItemList.length - 1];
    const event: ShortcutMenuClickEvent = {
      type: ShortcutMenuClickItem.ITEM_NONE,
      formStackID: this.mFormStackItem.formStackId as string,
      area: this.mFormStackItem.area,
      topCardPackageName: this.mViewModel.mItemInfoList[this.mViewModel.mItemInfoList.length - 1]?.bundleName,
      sourceType: Extend1Data.getCardSourceType(cardItemInfo.extend1),
      formType: FormCommonUtil.getFormType(
        this.mViewModel.mItemInfoList[this.mViewModel.mItemInfoList.length - 1]?.gamecardInfo),
    };
    FormStackHiSysEventUtil.reportClickShortcutMenu(event);
  }

  private updateTopCardId(): void {
    if (this.isAnimateListInvalid()) {
      log.showError('form list empty, set top cardId failed');
      return;
    }

    this.slideFormIndex = this.mFormItemList.length - 1;
    this.mFormStackTopCardId = this.mFormItemList[this.slideFormIndex].cardId;
    this.mCurrentFormItem = this.mFormItemList[this.slideFormIndex];
    log.showWarn(`update top cardId, list length: ${this.mFormItemList.length}, cardId: ${this.mFormStackTopCardId},` +
      `bundleName: ${this.mFormItemList[this.slideFormIndex].bundleName}`);

    this.mStaticMaskExtraWidth = FormStackUtil.getFormStackMaskExtraWidth(this.mFormItemList.length);
    EvtBus.post(VoiceInStackExposeEvent, createVoiceInStackExposeEvent(
      this.mFormStackItem.layoutInfo[0], this.mFormStackItem.page, this.mCurrentFormItem));
  }

  private isFormStackIdMatch(): boolean {
    return this.mFormStackItem.formStackId === FormStackManager.getInstance().getFormStackId();
  }

  private getCardInfo(card: FormStackAnimateItem): CardItemInfo | undefined {
    if (CheckEmptyUtils.isEmpty(card)) {
      log.showError('card animate item is invalid');
      return undefined;
    }

    let idx: number = this.getCardIdxInFormList(`${card.bundleName}${card.formId}`);
    if (idx < 0) {
      log.showError(`get card from list fail: ${card?.formId}`);
      return undefined;
    } else {
      return this.mFormItemList[idx];
    }
  }

  private getCardIdxInFormList(key: string): number {
    let idx: number = this.mFormItemList.findIndex(item => {
      return `${item.bundleName}${item.cardId}` === key;
    });
    return idx;
  }

  /**
   * 向堆叠添加完成卡片，清除落位动效相关参数
   */
  private clearDropAddCardAnimateParam(): void {
    this.mIsFormStackBackgroundOpen = false;
    this.mFormStackMaskOpacity = 0;
    this.mFormStackScale = 1;
    this.mFormStackOffset = 0;
    log.showInfo('backboard disappear by dropping card');
  }

  private isFormStackHidden(): boolean {
    log.showInfo(`isFormStackHidden[${this.mFormStackItem.formStackId}]: ` +
      `card length: ${this.mFormItemList.length}, isMenuAppear: ${this.isMenuAppear}`);
    return this.mFormItemList.length < FormStackConstants.FORM_STACK_ITEM_MIN_LEN ||
      (this.openFormStackFlag && this.isFormStackIdMatch()) || this.isMenuAppear;
  }

  private syncFormStackLayout(): void {
    let tempForms: CardItemInfo[] = [];
    tempForms.push(...this.mFormItemList);
    this.mFormStackItem.layoutInfo[0] = tempForms;
    this.updateCardOrder();
    // 同步更新缓存
    const cache: FormStackItemInfo = FormLayoutCacheManager.getInstance().selectGridLayoutItemByFormstackId(
      this.mFormStackItem.formStackId) as Object as FormStackItemInfo;
    if (cache) {
      cache.layoutInfo[0] = tempForms;
    }

    this.mEvent.syncFormItemList(this.mFormItemList);
    log.showInfo('form stack layout sync done');
  }

  private fixCardDimension(): boolean {
    let cardDimension: number = 0;
    let idx: number = this.mFormItemList.findIndex(item => {
      return FormStackUtil.isValidCardType(item.cardDimension);
    });

    if (idx < 0) {
      log.showError('all card dimensions are abnormal, no fix required');
      return false;
    }

    cardDimension = this.mFormItemList[idx].cardDimension;
    log.showInfo(`the card dimension is ${cardDimension}`);
    if (this.isOuterDesktop) {
      let style: FormComponentDisplayStyle = FormComponentConfig.getInstance().getFormComponentDisplayStyle(
        cardDimension, { width: this.mFormStackItemWidth, height: this.mFormStackItemHeight });
      let outerScale: number = style.displayRate ?? 1;
      log.showInfo(`init outer form stack expand scale ${outerScale} when open in outer desktop`);
      FormComponentConfig.getInstance().setOuterFormStackExpandScale(outerScale);
      PageDesktopModel.getInstance()?.setOuterFormStackExitScale(outerScale);
    }
    this.mFormItemList.forEach((item) => {
      if (!FormStackUtil.isValidCardType(item.cardDimension)) {
        log.showWarn(`abnormal card dimension, cardId: ${item.cardId} cardDimension: ${item.cardDimension}`);
        item.cardDimension = cardDimension;
      }
    })
    return true;
  }

  private dealTouchStatus(touchType: TouchType): void {
    if (touchType === TouchType.Down) {
      TraceUtil.traceOnce(DomainName.SCB, TraceUtil.CORE_METHOD_FS_TOUCH_DOWN);
      log.showInfo('set form stack touch status: true');
      this.isFormStackTouch = true;
      let lastFormStackItem: FormStackAnimateItem | undefined =
        this.mFormStackForeachList[this.mFormStackForeachList.length - 1];
      if (!lastFormStackItem ||
        (lastFormStackItem.mOpacity < 1 && this.mAnimateState === SlideOperateType.DEFAULT_STATE)) {
        return;
      }
      this.getFormStackSnapshot();
      if (AiSuggestionUtil.isVoiceAbilityForm(this.mCurrentFormItem.bundleName, this.mCurrentFormItem.abilityName)) {
        GlobalContext.getContext()?.eventHub.emit('appIconLongPressEffectCancel', true);
      }
      return;
    }

    if (touchType === TouchType.Up && !this.showMenu) {
      this.dragSnapshot?.release();
    }

    TraceUtil.traceOnce(DomainName.SCB, TraceUtil.CORE_METHOD_FS_TOUCH_UP);
    // 延时状态释放，防止与全搜手势事件冲突
    setTimeout(() => {
      log.showWarn('release gesture');
      this.isFormStackTouch = false;
      this.isDragging = false;
    }, 15);
  }

  private resetAnimateStatusByTouch(): void {
    log.showInfo(`form stack touch down, mAnimateState: ${this.mAnimateState}`);
    this.needUpdateDragSnapShot = false;
    if (this.mAnimateState === SlideOperateType.DEFAULT_STATE) {
      return;
    }
    this.needUpdateDragSnapShot = true;
    if (this.mAnimateState !== SlideOperateType.SLIDE_DOWN_SUCCESS) {
      this.resetStackFormStatus();
      return;
    }

    animateTo({
      duration: 0,
      onFinish: () => {
        log.showInfo('slide down animate reset done by touching');
      }
    }, () => {
      this.resetStackFormStatus();
    })
  }

  private getFormArea(): number {
    if (CheckEmptyUtils.isEmptyArr(this.mFormItemList)) {
      return CardAreaType.LARGE;
    }

    switch (this.mFormItemList[0].cardDimension) {
      case FormDimension.Dimension_1_2:
      case FormDimension.Dimension_2_1:
        return CardAreaType.SMALL;
      case FormDimension.Dimension_2_2:
      case FormDimension.Dimension_2_4:
        return CardAreaType.MIDDLE;
      case FormDimension.Dimension_4_4:
      default:
        return CardAreaType.LARGE;
    }
  }

  private initPressAnimParams(): void {
    let area: number = this.getFormArea();
    if (area === CardAreaType.SMALL) {
      this.mPressCurve = curves.interpolatingSpring(1, 1, 410, 38);
      this.mPressScale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_90;
    } else if (area === CardAreaType.MIDDLE) {
      this.mPressCurve = curves.interpolatingSpring(0.5, 1, 350, 35);
      this.mPressScale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
    } else {
      this.mPressCurve = curves.interpolatingSpring(0, 1, 240, 28);
      this.mPressScale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
    }
  }

  private playLongPressAnimation(isZoomOut: boolean, endScale?: number): void {
    if (isZoomOut) {
      log.showInfo(`formStackView long press zoom out`);
      animateToImmediately({
        curve: this.mPressCurve,
        playMode: PlayMode.Normal,
      }, () => {
        this.formItemComponentScale = { x: this.mPressScale, y: this.mPressScale };
      });
    } else {
      log.showInfo(`formStackView long press zoom in`);
      animateTo({
        duration: NumberConstants.CONSTANT_NUMBER_250,
        curve: Curve.Friction,
        playMode: PlayMode.Normal,
      }, () => {
        this.formItemComponentScale = { x: endScale ?? StyleConstants.DEFAULT_1,
          y: endScale ?? StyleConstants.DEFAULT_1 };
      });
    }
  }

  private getMenuItemNum(): number {
    this.formStackMenuInfoList = this.mFormStackMenuViewModel?.getFormStackMenuInfoList(this.mCurrentFormItem);
    this.cardMenuInfoList = this.mFormStackMenuViewModel?.getFormMenuInFormStack(this.mCurrentFormItem,
      this.mCoverFormItem, this.menuName, this.deleteFormStackFunc);
    let menuItemNum = (this.formStackMenuInfoList?.length ?? 0) + (this.cardMenuInfoList?.length ?? 0);
    return menuItemNum;
  }

  private setAppMenuPosition(event: TouchEvent): void {
    if (!event?.target?.area?.globalPosition?.y) {
      log.showError('setAppMenuPosition event is null');
      return;
    }

    if (!FormStackViewModel.isSupportFormStack() || event.type !== TouchType.Down) {
      return;
    }

    let menuItemNum: number = this.getMenuItemNum();
    let formStackRect: RectInfo = ItemUtils.getRectById(this.mFormStackBuilderId);
    this.menuPlacement = MenuCommonUtil.getMenuPlacement(event, formStackRect, menuItemNum, GROUP_NUM);
  }

  private getFormStackSnapshot(): void {
    const componentId = FormStackUtil.getFormStackComponentId(this.mFormStackItem.formStackId);
    dragSnapshotHelper.snapshotFromId(componentId, SnapshotType.BOTH,
      GridLayoutUtil.generateUniqueKey(this.mFormStackItem as Object as GridLayoutItemInfo),
      (value: image.PixelMap) => {
        log.showInfo(`get formstack snapshot done.`);
        this.dragSnapshot = value;
      }, undefined, undefined, `FormStackView_getFormStackSnap`);
  }

  private buildExpandItemInfo(isByMenu: boolean): OpenFormStackStateInfo {
    let openInfo: OpenFormStackStateInfo = new OpenFormStackStateInfo();
    openInfo.mWidth = this.mFormStackItemWidth;
    openInfo.mHeight = this.mFormStackItemHeight;
    this.mViewModel.mItemInfoList.forEach((item: FormStackAnimateItem) => {
      if (item.mUseEffect) {
        openInfo.mUseEffectComIds.push(item.formId);
      }
    });
    const componentId = FormStackUtil.getFormStackComponentId(this.mFormStackItem.formStackId);
    let position: RectInfo = ItemUtils.getRectById(componentId, this.getUIContext());
    // 堆叠stack组件实际位置偏移了6vp
    position.top += Math.abs(this.mFixedOffsetY);
    log.showWarn(`formstack position, left: ${position.left}, top: ${position.top}`);
    openInfo.position = position;
    openInfo.mIsOpenByMenu = isByMenu;
    if (!isByMenu) {
      // 长滑展开首张卡片临界状态
      openInfo.mTopItem.mScaleX = (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downMaxScaleX;
      openInfo.mTopItem.mScaleY = (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downMaxScaleY;
      openInfo.mTopItem.mRotateAngle = (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).downMaxRotateAngle;
      openInfo.mTopItem.mOpacity = this.mViewModel.mItemInfoList[this.slideFormIndex].mOpacity;
    }
    openInfo.mTopItem.mTranslateY = isByMenu ? position.top :
      (position.top + this.mFormStackItemHeight * FormStackConstants.SLIDE_DOWN_MAX_TRANSLATE_Y_RATIO);
    openInfo.mDefaultItem.mScaleX = this.mSizeRatio;
    openInfo.mDefaultItem.mScaleY = this.mSizeRatio;
    openInfo.mDefaultItem.mRotateAngle =
      (this.mSlideAnimate.slideAnimateParam as SlideAnimateParam).behindFormRotateAngle;
    openInfo.mDefaultItem.mTranslateY = position.top + this.mFixedOffsetY;
    openInfo.formStackScale.x = this.formItemComponentScale.x;
    openInfo.formStackScale.y = this.formItemComponentScale.y;
    log.showInfo(`open form stack, mWidth: ${openInfo.mWidth}, mHeight: ${openInfo.mHeight}`);
    return openInfo;
  }

  private reportSlideResult(slideType: number, bundleName: string): void {
    const event: SwitchCardsEvent = {
      formStackID: this.mFormStackItem.formStackId as string,
      area: this.mFormStackItem.area,
      screenPage: this.mFormStackItem.page,
      column: this.mFormStackItem.column,
      row: this.mFormStackItem.row,
      topCardPackageName: bundleName,
      slideType: slideType,
    };
    FormStackHiSysEventUtil.reportSwitchCards(event);
  }

  private notifySlideItem(isUp?: boolean): void {
    let eventInfo: EventInfo = new EventInfo();
    eventInfo.stackId = this.mFormStackItem.formStackId as string;
    eventInfo.formStackItem = this.mFormStackItem;
    eventInfo.actionName = EventConstants.EVENT_FORM_STACK_SLIDE_CARD;
    if (isUp !== undefined && this.mFormItemList.length >= 2) {
      eventInfo.preCardItemInfo = this.mFormItemList[this.mFormItemList.length - 1];
      if (isUp) {
        eventInfo.cardItemInfo = this.mFormItemList[0];
      } else {
        eventInfo.cardItemInfo = this.mFormItemList[this.mFormItemList.length - 2];
      }
      eventInfo.cardItemInfoArr = this.mFormItemList;
    }
    if (isUp !== undefined) {
      GlobalContext.getContext()?.eventHub.emit(EventConstants.EVENT_FORM_STACK_ITEM_STATUS_CHANGE_EVENT, eventInfo);
    }
  }

  /**
   * 堆叠只有两张卡片时，蒙层轮转效果优化
   * 场景一：仅上滑，蒙层下移隐藏
   * 场景二：反方向滑动
   * 1）上滑转下滑，蒙层与卡片同步上移
   * 2）下滑转上滑，蒙层单独下移
   * @param isDownShift 蒙层上/下移
   * @param isWithCard 背部卡片是否跟随移动
   */
  private maskDownshiftAnimate(isDownShift: boolean, isWithCard: boolean = false): void {
    if (FormStackUtil.isInvalidFormStackList(this.mFormItemList)) {
      log.showInfo('mask downshift failed, formstack item list invalid!');
      return;
    }

    if (this.mFormItemList.length > FormStackConstants.FORM_STACK_ITEM_MIN_LEN) {
      // 超过两张卡片不处理
      return;
    }

    if (!isDownShift && isWithCard) {
      // 先上翻再反向跟手
      this.mViewModel.mMaskList[0].mTranslateY = Math.abs(this.mFixedOffsetY);
      this.mViewModel.mItemInfoList[0].mTranslateY = Math.abs(this.mFixedOffsetY);
    }

    log.showInfo(`mask down shifting, isDownShift: ${isDownShift}, isWithCard: ${isWithCard}`);
    animateTo({
      duration: 80,
      curve: Curve.Friction,
    }, () => {
      this.mViewModel.mMaskList[0].mTranslateY = isDownShift ? Math.abs(this.mFixedOffsetY) : 0;
      if (isWithCard) {
        this.mViewModel.mItemInfoList[0].mTranslateY = isDownShift ? Math.abs(this.mFixedOffsetY) : 0;
      }
    });
  }

  private handleGestureJudge(gestureInfo: GestureInfo): GestureJudgeResult {
    if (gestureInfo.type === GestureControl.GestureType.PAN_GESTURE &&
      scbEventExclusiveManager.isExclusive(EventType.FORMSTACK_GESTURE)) {
      log.showWarn('desktop item in operating, formstack do not response gesture.');
      return GestureJudgeResult.REJECT;
    }

    return GestureJudgeResult.CONTINUE;
  }

  private radiusChange(): void {
    this.mViewModel.setNewRadius(this.mFormBorderRadius);
  }

  private onOuterMenuDragStart: ()=> void = () => {
    this.isDragging = true;
    this.showMenu = false;
    this.resetFormStackOfMisSlide();
  }

  private onOuterMenuDragEnd: ()=> void = () => {
    AppStorage.setOrCreate<boolean>('isDrag', false);
    AppStorage.setOrCreate<Object>('dragItemInfo', {});
    // 拖拽不回调touch up事件，需要在dragEnd中释放
    this.isFormStackTouch = false;
    this.isDragging = false;
    this.playLongPressAnimation(false);
    if (this.isMenuAppear) {
      this.isMenuAppear = false;
    }
  }

  private updateDragSnapShot(): void {
    log.showInfo('updateDragSnapShot in');
    this.needUpdateDragSnapShot = false;
    try {
      dragSnapshotHelper.setSnapshot(componentSnapshot.getSync(FormStackUtil.getFormStackComponentId(
        this.mFormStackItem.formStackId)), SnapshotType.BOTH,
        GridLayoutUtil.generateUniqueKey(this.mFormStackItem as Object as GridLayoutItemInfo));
    } catch (e) {
      log.showError(`update form stack snap fail: ${e?.code}`);
    }
  }
}

export class BlendModeParam {
  @Track public value: number | null = null;
  @Track public type: number | null = null;
}