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

import { NtfListVm } from '../../model/NtfListVm';
import { NotificationEntry } from '../../model/NotificationEntry';
import { NtfListScrollController } from '../../controller/NtfListScrollController';
import {
  CommonUtils,
  DomainName,
  LogDomain,
  LogHelper,
  Trace,
  TraceUtil,
  RectInfo,
  AnimateToScheduleUtils
} from '@ohos/basicutils';
import {
  DropDownEvent,
  EventManager,
  EvtBus,
  HiDfxEventUtil,
  TargetPanel,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { ItemUtils } from '@ohos/componenthelper';
import { DeviceModeEnum } from '@ohos/commonconstants';
import { DropDownPanelConstants, DropDownPanelManager, ProgressCardAnimVm,
  OhterCardExtendAnimVm,
} from '@ohos/systemuicommon/Index';
import { NotificationConfig } from '../../common/NotificationConfig';
import curves from '@ohos.curves';
import { NotificationListItem } from './NotificationListItem';
import { NotificationAnimationParas } from '../../common/NotificationAnimationParas';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { NotificationExtraHeader } from './NotificationExtraHeader';
import { NotificationExtraContentBrief } from './NotificationExtraContentBrief';
import { NotificationSettings } from '../common/NotificationSettings';
import { NotificationClose } from '../common/NotificationClose';
import { NtfCloseVM } from '../../vm/NtfCloseVM';
import { NtfDataChangeType } from '../../model/NotificationListAdapter';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import NtfDropdownController from '../../controller/NotificationDropdownController';
import { ntfViewConfigManager } from '../../vm/config/NtfViewConfigManager';
import { NtfListContentConfig } from '../../vm/config/NtfViewConfig';
import { NtfAnimVM } from '../../vm/NtfAnimVM';
import { NotificationConstants, SCBFoldState } from '../../common/NotificationConstants';
import { blurButtonVM } from '../../vm/BlurButtonVM';
import {
  CardScaleType,
  CardScaleUtil,
  EmergencyThermalAppType, getIsInEmergencyOrThermalSafeMode,
  LiveUseScene, fontScaleManager, FontScaleState, FrameCount } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { NtfAnimationConsts } from '../../common/NtfAnimationConsts';
import { NtfClearAllAnimation } from '../../animation/NtfClearAllAnimation';
import {
  NotificationPanelSlideParams,
  NotificationSysEventReporter,
  SlideType,
} from '@ohos/systemuicommon/src/main/ets/utils/NotificationSysEventReporter';
import sDropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ExtraNtfCollapsedAnimation } from '../../animation/ExtraNtfCollapsedAnimation';
import {
  NtfAnimateEvent,
  NtfPinnedEvent,
  NtfListScrollEvent,
  NtfSwipeDeleteEvent,
  GroupItemExpandingEvent,
  ExtraNtfCollapseEvent,
} from '../../common/event/NotificationEvent';
import { NtfScrollAnimation } from '../../animation/NtfScrollAnimation';
import { AttributeUpdater, LengthMetrics } from '@kit.ArkUI';
import { default as SysFloatTipDialog } from '@ohos/screenlockcommon/src/main/ets/templateView/SysFloatTipDialog';
import { ScreenLockNotificationConst } from '@ohos/screenlockcommon/src/main/ets/constants/ScreenLockNotificationConstants';
import { NotificationGroupExpandAnimation } from '../../animation/NotificationGroupExpandAnimation';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { NotificationListStyle } from '../../vm/style/NotificationListStyle';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { NotificationDataManager } from '@ohos/systemuicommon/newTsIndex';
import { EmergencyThermalSafeManager } from '@ohos/systemuicommon/src/main/ets/manager/EmergencyThermalSafeManager';
import { ntfListener } from '../../model/NotificationListener';
import { AccessibilityUtil } from '@ohos/systemuicommon';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { ListContentAccessibility, GroupAccessibility } from '../../utils/NotificationAccessibility';
import { ActionInterceptor, ActionInterceptorManager } from '../../manager/ActionInterceptorManager';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { ntfSettingsDC } from '../../controller/NtfSettingsDialogController';
import { DISABLE_HEAD_BLUR_EFFECT } from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';

const TAG = 'NotificationListContent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 列表平移时的权重
 */
const LIST_TRAN_WEIGHT = 1.05;

/**
 * 触发底部关闭控制中心的范围
 */
const BOTTOM_TRIGGER_RANGE: number = 10;

/**
 * 触发内存回收时展示用户能看到的通知数量
 */
const NTF_SHOW_NUM: number = 8;

const NTF_EXTRA_CONTENT_BRIEF_ID: string = 'NotificationExtraContentBrief_NtfCenter';

/**
 * 链式动效间隔高度阈值
 */
const CHAIN_MAX_OFFSET: number = 80;

/**
 * 通知卡片最大缩放
 */
const NTF_TRANSLATE_MIN_SCALE: number = 0.92;

/**
 * Delay time of notification items when drop down notification
 */
const APPEAR_DELAY: number = 32;

/**
 * Delay time of notification items when pull up notification
 */
const DISAPPEAR_DELAY: number = 16;

/**
 * Scale of notification items
 */
const ITEM_SCALE: number = 0.93;

/**
 * Translate Y of notification items
 */
const ITEM_TRANSLATE_Y: number = ArkUIAdapter.px2vp(-150);

/**
 * Parameters for shape animation
 */
const SHAPE_ANIMATION_DURATION: number = 250;

const SHAPE_ANIMATION_CURVE: ICurve = curves.cubicBezierCurve(0.2, 0, 0.2, 1);

const TRANSLATE_Y_DISAPPEAR_ANIMATION_DURATION: number = 248;

const TRANSLATE_Y_APPEAR_ANIMATION_CURVE: ICurve = curves.interpolatingSpring(0, 1, 228, 30);

const TRANSLATE_Y_DISAPPEAR_ANIMATION_CURVE: ICurve = curves.cubicBezierCurve(0.2, 0, 0.2, 1);

/**
 * Parameters for opacity animation
 */
const OPACITY_APPEAR_ANIMATION_DURATION: number = 250;

const OPACITY_DISAPPEAR_ANIMATION_DURATION: number = 50;

const OPACITY_ANIMATION_CURVE: Curve = Curve.Linear;
/**
 * 通知卡片上滑时，第一张卡片的透明度需要快速达到这个值
 */
const OPACITY_THRESHOLD: number = 0.8;
/**
 * 通知卡片上滑时，第一张卡片的透明度快速增长倍数
 */
const OPACITY_GROWTH_MULTIPLIER: number = 2.5;
/**
 * 更多通知展开，空间不够默认展示通知数量
 */
const EXTRA_NTF_EXPAND_DEFAULT_SHOW_COUNT: number = 3;

/**
 * 一键删除剩余卡片归位的动效时间，设置为最小值，保证delay可以生效。
 */
const CLEAR_ALL_REMAIN_ITEM_ANIMATION_DURATION: number = 1;

/**
 * 通知卡片最大层级
 */
const NTF_MAX_Z_INDEX: number = 100;
/**
 * 更多通知折叠展开动效id
 */
const EXTRA_NTF_TRANSITION_ID: string = 'extra_ntf_transition_id_';

const TRANSPARENT_CARD_ID: string = 'transparent_card'

/**
 * 可展开的最后一张卡片距离列表底部展开时触发向上滚动的阈值
 */
const SCROLL_UP_LAST_CARD_THRESHOLD = 20;

/**
 * 通知需要向上滚动时，向上滚动高度
 */
const SCROLL_UP_HEIGHT = 100;

export class DeleteNtfInfo {
  public entry: NotificationEntry | undefined = undefined;
  public groupKey: string | undefined = undefined;
  public index: number = -1;
  public isExtraNtf: boolean = false;
  public realHeight: number = 0;

  constructor(entry:NotificationEntry, index: number, realHeight: number) {
    this.entry = entry;
    this.groupKey = entry.getGroupKey();
    this.index = index || 0;
    this.isExtraNtf = entry.isExtraContentType();
    this.realHeight = realHeight || 0;
  }
  reset() {
    this.entry = undefined;
    this.groupKey = undefined;
    this.index = -1;
    this.isExtraNtf = false;
    this.realHeight = 0;
  }
}
class NtfListItemModifier extends AttributeUpdater<ListItemAttribute> {
  initializeModifier(instance: ListItemAttribute): void {
    instance.zIndex(0)
  }
}
/**
 * 通知列表数据
 */
@Component
export struct NotificationListContent {
  @State ntfList: Array<NotificationEntry> = [];
  @State mainNtfList: Array<NotificationEntry> = [];
  @Provide extraNtfList: Array<NotificationEntry> = [];
  /**
   * 是否回收资源
   */
  @Consume trimMemory: boolean;
  /**
   * 通知中心下滑最大距离
   */
  private maxDropDownDis: number = 0;
  /**
   * VM
   */
  private ntfListVM: NtfListVm | undefined = undefined;
  /**
   * 列表滑动控制器
   */
  private listScroller: NtfListScrollController | undefined = undefined;

  /**
   * 是否正在滑动
   */
  private isScrolling: boolean = false;

  /**
   * 滑动状态
   */
  private scrollState: ScrollState = ScrollState.Idle;

  /**
   * 通知列表是否正在变化
   */
  private isNtfListChanging: boolean = false;
  /**
   * 下拉事件
   */
  private dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();

  @StorageLink('isPanelAnimationDone') @Watch('onAnimationFinish') isPanelAnimationDone: boolean = true;
  /**
   * 是否无数据
   */
  @Consume @Watch('onNtfEmptyListChange') isNtfListEmpty: boolean;

  @Link isShowNtfEmptyTips: boolean;

  /**
   * 通知头部跟随平移值
   */
  @Consume ntfFollowTranY: number;
  @Consume listHeadTranY: number;
  /**
   * 通知头部跟随平移动画
   */
  @Consume ntfFollowAnim: AnimateParam | null;
  /**
   * 下拉面板时跟随平移值
   */
  @State listFollowTranY: number = 0;
  @State ntfAnimationParas: Map<string, NotificationAnimationParas> = new Map();
  private listItemModifier: Map<string, NtfListItemModifier> = new Map();
  /**
   * y轴下拉跟手系数
   */
  transYCoefficient: number = 2 / 3;

  @State emptyListTipOpacity: number = 0;
  /**
   * 用来刷新界面的同步量
   */
  @State radiusSyncState: number = 0;
  /**
   * 滑动效果
   */
  @State edgeEffect: EdgeEffect = EdgeEffect.Spring;
  /**
   * 列表padding
   */
  @State listPadding: Padding | Length = 0;
  /**
   * 记录List中每个Item的radius
   */
  private borderRadiusMap: Map<string, number> = new Map();
  /**
   * 触底时的滑动偏移量
   */
  private reachEndOffset: number = 0;
  /**
   * 第一次触底不关闭，触底后第二次上滑关闭
   */
  private isAlreadyReachEnd: boolean = false;
  /**
   * 是否触发底部拖动关闭
   */
  private isDragFromBottom: boolean = false;
  /**
   * 仅用于回弹过程中使用：标记单次操作是否为上滑
   */
  private itemScrollOffset: number = 0;
  /**
   * 仅用于回弹过程中使用：标记单次操作是否为上滑
   */
  private startScrollOffset: number = 0;
  /**
   * 仅用于回弹过程中使用：标记上滑是否已过底部
   */
  private isAlreadyOverEnd: boolean = false;
  /**
   * 仅用于回弹过程中使用：标记前一次上滑是否已过底部
   */
  private isAlreadyEverEnd: boolean = false;
  /**
   * 控制List的opacity, 桌面下拉时先把List透明度置为0, 待卡片参数设置完毕后再恢复为1, 避免闪烁
   */
  @State hasInitOpacity: boolean = true;
  /**
   * 是否显示底部占位卡片
   */
  private isShowBottomTransCard: boolean = true;

  /**
   * 底部卡片展开的上滑高度
   */
  private scrollHeight: number = 0

  /**
   * 动效vm
   */
  @State ntfAnimVM: NtfAnimVM | undefined = undefined;

  /**
   * touch起始点
   */
  private touchStartX: number = 0;
  private touchStartY: number = 0;

  /**
   * list组件的最后一个可见item的index
   */
  lastIndex: number = 0;
  /**
   * list组件的第一个可见item的index
   */
  firstIndex: number = 0;
  /**
   * 保存一键删除待删通知的索引，用于transition动效参数
   */
  clearAllNtfIndexMap: Map<NotificationEntry, number> = new Map();
  /**
   * 用于临时记录最后一个可见item的index
   */
  private tempLastIndex: number = 0;
  /**
   * List组件显示区域
   */
  @Provide listArea: Area | undefined = undefined;
  /**
   * 通知卡片所占区域
   */
  @Link ntfAreaRect: RectInfo;
  /**
   * 一键删除过程中，使用对应的转场动效
   */
  @State isInClearAllTransition: boolean = false;
  private isNtfShow: boolean = false;
  @Consume @Watch('onScreenOrientationChanged') isDisplayLand: boolean;
  @Consume @Watch('onFoldFullDisplayChange') isFoldFullDisplay: boolean;
  private isClearAllEmptyShowTipsAnim: boolean = false;
  private clearAllFlag: boolean = false;
  private phoneNtfListHeight: number = 0;
  private animationCount: number = 0;
  private deleteNtfInfo?: DeleteNtfInfo;
  /**
   * 横竖屏是否切换，用于切换后刷新动效仿射参数
   */
  private orientationChanged: boolean = false;
  /**
   * 记录左滑状态的通知的哈希值，用于左滑状态互斥（同一时刻，只允许一条通知左滑）
   */
  @Provide swipeHashCode: string = '';
  /**
   * 横竖屏转换
   */
  @StorageLink('isLandscape') @Watch('onOrientationChanged') isLandscape: boolean = false;
  // ---------------------------------------------更多通知相关属性 start -------------------------------------------------
  /**
   * 更多通知列表是否处于折叠态
   */
  @Provide @Watch('onIsCollapsedUpdated') isExtraNtfsCollapsed: boolean = false;
  /**
   * 更多通知折叠态摘要卡片缩放
   */
  @State extraNtfsCollapsedBriefScale: number = 1;
  /**
   * 是否在展开或折叠过程中
   */
  @State @Watch('onCollapseStatusChanging') isExtraNtfsCollapseStatusChanging: boolean = false;
  /**
   * 更对通知折叠收起动效管理类
   */
  private extraNtfCollapsedAnimation: ExtraNtfCollapsedAnimation = new ExtraNtfCollapsedAnimation();
  /**
   * 更多通知动效参数
   */
  @State extraNtfsTransitionAnimations: TransitionEffect[] = [];
  /**
   * 更多通知折叠态实体
   */
  @State extraBrief: NotificationEntry | undefined = undefined;
  /**
   * 是否在折叠状态下重新创建卡片
   */
  @State isCreatedExtraBriefWhenCollapsed: boolean = false;
  /**
   * 是否需要一镜到底动效
   */
  @State isNeedGeometryTransition: boolean = true;
  // ---------------------------------------------更多通知相关属性 end  -------------------------------------------------

  /**
   * close按钮VM
   */
  @Provide private closeVM?: NtfCloseVM = undefined;

  private isEnableScrollAnimation: boolean = true;

  @Prop maxHeight: Length = Infinity;

  @BuilderParam private emptyTipBuilder?: () => void;

  @Link ntfListTranslate: number;

  @State translateYArr: number[] = [];

  private changeAppPinTopConfig?: (enable: boolean) => void;

  private deleteAnimSyncFlag: boolean = false;

  private deleteAnimSyncData: Array<NotificationEntry> | undefined;

  /**
   * 多事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * 记录展示按钮的通知的哈希值，用于互斥操作
   */
  @Provide displayButtonsHashCode: string = '';

  private opacityAnimCountRecords: Map<string, number> = new Map();

  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  colorModeVM: NtfColorModeVM | undefined = undefined;

  private listContentConfig: NtfListContentConfig = ntfViewConfigManager.getListContentConfig();

  private expandedItem: string | undefined = undefined;

  private changeIndex: number = 0
  /**
   * 删除补位链式动效方向
   */
  private chainDirection: string = 'bottom';
  /**
   * 是否切圆角
   */
  @State clipParam: boolean = this.listContentConfig.clipParam;

  /**
   *  应急模式应用列表
   */
  @StorageProp('emergencyInfoList') @Watch('onEmergencyInfoListChange') emergencyInfoList: EmergencyThermalAppType[] = [];

  /**
   *  应急模式状态
   */
  @StorageProp('deviceModeState') @Watch('onChangeDataEmitter') deviceModeState: DeviceModeEnum = DeviceModeEnum.BASE_MODE;

  /**
   *  应急模式应用包名数据集
   */
  private emergencyWhiteList: string[] = [];
  /**
   * 透明卡片高度
   */
  @State transparentCardHeight: number = 0;
  /**
   * 一键清除动效管理
   */
  private ntfClearAllAnimation: NtfClearAllAnimation | undefined = undefined;
  /**
   * 通知列表滑动动效
   */
  private ntfScrollAnimation: NtfScrollAnimation = new NtfScrollAnimation();

  private listRectInfo: RectInfo | undefined = undefined;

  private backgroundFocusable: boolean = true;

  @State isDropDownAniFin: boolean = false;
  /**
   * 是否下拉
   */
  private isDropDownPanel: boolean = false;
  /**
   * 主通知的动效参数
   */
  @State mainNtfAnimation: TransitionEffect | undefined = undefined;

  private protectedVm: AppProtectedVm = AppProtectedVm.get();

  @Prop isNeedPanelInScreenLock: boolean = false;
  @Prop isShowBannerFromScreenLock: boolean = false;
  @Prop isLockScreen: boolean = false;
  @Prop isSecureAndLocked: boolean = false;
  /**
   * 组通知是否在展开过程中
   */
  @State isGroupExpanding: boolean = false;
  /**
   * 组通知展开过程中定时器id
   */
  private groupExpandingTimerId: number | undefined = undefined;

  /**
   * 通知列表类型
   */
  @Consume notificationType: number;

  /**
   * 长辈模式字体
   */
  @State @Watch('refreshExtraNtfMinHeight') fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  /**
   * 更多通知卡片最小高度，设置最小高度，更多通知展开时提前占位
   */
  @State extraNtfMinHeight: number = 0;
  /**
   * 更新数据中
   */
  @State isUpdatingData: boolean = false;
  private updatingItemKey: string = '';
  private updateDataInterceptor?: ActionInterceptor;
  // 是否半叠状态
  @Prop isHalfFold: boolean = false;
  @Prop contentStartOffset: number = 0;
  private updateFirstCardTransY?: (firstCardTransY: number) => void;
  // 通知卡片与通知中心面板头分帧渲染,减少响应时延
  @State isRootLoad: boolean = false;

  aboutToAppear(): void {
    // 下拉面板，需要监听跟随平移
    if (this.ntfListVM) {
      this.ntfListVM.refreshItemZIndex = this.updateNtfZIndexParam;
      this.ntfListVM.raiseItemToTop = this.maximizesZIndex;
    }
    if (this.ntfListVM?.isDropdown()) {
      this.listScroller?.registerOnFollowTranChangeListener(this);
      this.listScroller?.registerOnClearAllListener(this);
      this.listScroller?.scrollToFirst();
      this.isAlreadyReachEnd = false;
      this.calculateNtfListHeight();
    }
    this.ntfList = this.ntfListVM?.getNtfAdapterList()!;
    this.mainNtfList = this.getMainNtfList();
    this.extraNtfList = this.getExtraNtfList();
    this.ntfListVM?.getNtfListAdapter()?.registerDataChangeListener(this);
    this.ntfListVM?.registerNtfListChangeListener(this);
    this.ntfListVM?.registerDisplayListener(this);
    this.closeVM?.registerNtfCloseListener(this);
    this.listRectInfo = this.getNtfListRowRectInfo();
    NtfScrollAnimation.listRect = this.getNtfListRowRectInfo();
    log.showInfo('NotificationListContent aboutToAppear ntfList: ' + this.ntfList?.length);
    this.setNtfListRadius();
    this.isShowNtfEmptyTips = this.getIsShowNtfEmptyTips();
    this.setContentTranslateY(this.listFollowTranY * this.transYCoefficient);
    this.eventMgr.on(NtfSwipeDeleteEvent, this.onNtfSwipeDeleteEvent)
      .on(NtfAnimateEvent, this.onNtfAnimateEvent)
      .on(NtfPinnedEvent, this.onNtfPinnedEvent)
      .on(GroupItemExpandingEvent, this.onGroupItemExpandingEvent)
      .on(ExtraNtfCollapseEvent, this.onExtraNtfCollapseEvent);
    this.mainNtfAnimation = this.ntfAnimVM?.ntfListItemTransition;
    this.listPadding = this.getPadding();
    this.refreshExtraNtfMinHeight();
    ActionInterceptorManager.instance.setInterceptor(NotificationConstants.UPDATE_DATA_INTERCEPTOR);
    this.updateDataInterceptor =
      ActionInterceptorManager.instance.getInterceptor(NotificationConstants.UPDATE_DATA_INTERCEPTOR);
    sDropDownPanelManager.isAllowSwitch = this.isAllowSwitch;
    sDropDownPanelManager.isInNtfVisibleList = this.isInNtfVisibleList;
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.eventMgr.offAll();
    this.listScroller?.unregisterOnFollowTranChangeListener(this);
    this.listScroller?.unregisterOnClearAllListener(this);
    this.ntfListVM?.getNtfListAdapter()?.unregisterDataChangeListener(this);
    this.ntfListVM?.unregisterNtfListChangeListener(this);
    this.ntfListVM?.unregisterDisplayListener(this);
    this.closeVM?.unregisterNtfCloseListener(this);
    ActionInterceptorManager.instance.clearInterrupt(NotificationConstants.UPDATE_DATA_INTERCEPTOR);
  }

  private getListItemModifier(key: string): NtfListItemModifier {
    if (!this.listItemModifier.get(key)) {
      this.listItemModifier.set(key, new NtfListItemModifier());
    }
    return this.listItemModifier.get(key)!;
  }

  onEmergencyInfoListChange(): void {
    // 应用编辑的通知刷新
    if (this.emergencyInfoList?.length > 0) {
      this.setEmergencyWhiteList(this.emergencyInfoList);
    };
    this.onNtfListDataChange(this.ntfListVM?.getNtfAdapterList() ?? []);
  };

  onChangeDataEmitter(): void {
    EmergencyThermalSafeManager.instance.setDeviceModeState(this.deviceModeState);
    let isInEmergencyOrThermalSafeMode = getIsInEmergencyOrThermalSafeMode(this.deviceModeState);
    if ((isInEmergencyOrThermalSafeMode && this.emergencyInfoList?.length > 0) ||
      (!isInEmergencyOrThermalSafeMode && (this.ntfListVM?.getNtfAdapterList() ?? []).length > 0)) {
      this.onNtfListDataChange(this.ntfListVM?.getNtfAdapterList() ?? []);
    }
    if (isInEmergencyOrThermalSafeMode) {
      // 进入应急模式
      if (this.deviceModeState === DeviceModeEnum.THERMAL_SAFE_MODE) {
        // 刷新热安全模式应用列表
        this.setEmergencyWhiteList(AppStorage.get('thermalInfoList'));
      }
    } else {
      // 退出应急模式
      this.ntfListVM?.exitEmergencyMode();
    }
  };
  onIsCollapsedUpdated() {
    // 折叠事多通知时，需要重置动效参数，防止上滑时卡片设置透明后展开时未恢复的场景
    if (this.showExtraNtfsCollapsed() && this.ntfAnimationParas.has(NTF_EXTRA_CONTENT_BRIEF_ID)) {
      this.ntfAnimationParas.set(NTF_EXTRA_CONTENT_BRIEF_ID, new NotificationAnimationParas(0, 0, 1, 1, 0));
    }
    if (!this.showExtraNtfsCollapsed() && this.lastIndex >= (this.mainNtfList.length + 1)) {
      // 更多通知展开时，上滑至最后一条更多通知位于屏幕底部
      this.listScroller?.setReachEnd(false);
      this.isAlreadyReachEnd = false;
      // 等待更多通知展开动效执行1/3的时候进行位移
      setTimeout(() => {
        // 避免更多通知条数过多时上滑太多
        let length = this.extraNtfList.length > EXTRA_NTF_EXPAND_DEFAULT_SHOW_COUNT ?
          this.mainNtfList.length + EXTRA_NTF_EXPAND_DEFAULT_SHOW_COUNT :
          this.mainNtfList.length + this.extraNtfList.length;
        this.listScroller?.getScroller().scrollToIndex(length, true, ScrollAlign.AUTO);
      }, this.extraNtfCollapsedAnimation?.extraNtfCollapsedDuration / 3);
    }
  }

  onCollapseStatusChanging(): void {
    if (!this.isExtraNtfsCollapseStatusChanging) {
      this.isNeedGeometryTransition = true;
    }
  }

  /**
   * 横竖屏切换回调
   */
  onOrientationChanged() {
    this.isAlreadyEverEnd = false;
    this.isAlreadyOverEnd = false;
    this.orientationChanged = true;
    this.listScroller?.setReachEnd(false);
    this.transparentCardHeight = 0;
    blurButtonVM.unblur();
  }
  /*
  * 折叠屏折叠展开回调
  */
  onFoldFullDisplayChange(): void {
    this.isShowNtfEmptyTips = this.getIsShowNtfEmptyTips();
  }
  /**
   * 更新通知动效配置参数
   *
   * @param key 通知分组标示
   */
  private updateAnimationParas: Function = (key: string): void => {
    if (this.ntfAnimationParas.get(key) && !this.clipParam) {
      this.updateNtfAnimationParas();
    }
  }

  private updateData(dataSource: Array<NotificationEntry>, useAnim: boolean = false) {
    this.animationCount++;
    // 排除空数据
    let isAdd = dataSource.length > this.ntfList.length;
    let deleteItems: NotificationEntry[] = [];
    deleteItems = this.ntfList?.filter(entry => {
      return !dataSource.find(i => i.getGroupTypeKey() === entry.getGroupTypeKey() &&
        i.deliveryTime === entry.deliveryTime)
    });
    if (deleteItems.length > 0 && dataSource.length > 2) {
      // 通知剩余条数较少时，不需要链式动效
      let deleteItem = deleteItems[0];
      if (deleteItem && !this.clearAllFlag) {
        this.initDeleteInfo(this.ntfList, deleteItem)
      }
      this.clearAllFlag = false;
    } else {
      this.deleteNtfInfo?.reset();
    }
    for (const deleteItem of deleteItems) {
      this.getListItemModifier(deleteItem.getGroupTypeKey()).attribute?.zIndex(-1);
    }
    this.ntfList = dataSource?.filter(entry => entry);
    this.mainNtfList = this.getMainNtfList();
    this.extraNtfList = this.ntfList?.filter(entry => entry.isExtraContentType());
    this.isShowNtfEmptyTips = this.getIsShowNtfEmptyTips();
    this.isNtfListChanging = true;
    this.mainNtfAnimation = this.ntfAnimVM?.ntfListItemTransition;
    if (deleteItems.length > 0) {
      // 删除通知，隐藏通知设置弹框
      this.hideSettingDialog(deleteItems);
      // 清空按钮是否置灰
      this.ntfListVM?.updateClearButtonState();
      this.updateNtfAnimationParas();
      this.releaseNtfListContentObj(deleteItems);
    } else {
      if (isAdd) {
        // 解决firstIndex>0时进新消息，通知下滑但top卡片位置未更新问题，此时firstIndex与lastIndex均未改变
        setTimeout(() => {
          this.updateNtfAnimationParas();
        })
      } else {
        // 非新增通知组的场景也需更新, 避免被更新的通知组（更新前未显示或堆叠显示）出现错位的情况
        this.updateNtfAnimationParas();
      }
    }
    this.setNtfListRadius();
    if (useAnim && this.isEnableScrollAnimation && deleteItems.length > 0) {
      this.updateBottomNtfAnimationParas();
    }
    this.hideMoreNtfActionButtons(this.isExtraNtfsCollapsed, false);
    log.showInfo('mainNtfList length : ' + this.mainNtfList.length + ', extraNtfList length : ' +
    this.extraNtfList.length);
  }

  private hideSettingDialog(deleteItems: Array<NotificationEntry>): void {
    if (ntfSettingsDC.isShowing(this.notificationType)) {
      const showSettingEntry = ntfSettingsDC.getNtfEntryByType(this.notificationType);
      if (!showSettingEntry) {
        return;
      }
      if (deleteItems.findIndex(item => item?.getGroupTypeKey() === showSettingEntry?.getGroupTypeKey()) >= 0) {
        ntfSettingsDC.hideDialog(this.notificationType);
      }
    }
  }

  private getIsShowNtfEmptyTips(): boolean {
    let isShowEmptyTips = this.ntfList.length > 0 ? false : true;
    log.showInfo(`IsShowNtfEmptyTips ${isShowEmptyTips}`);
    return isShowEmptyTips;
  }

  private updateChainAniParams(index: number) {
    let maxIndex = this.getMaxIndex();
    for (let i = 0; i <= maxIndex; i++) {
      const key = this.getListItemKey(i);
      if (!key) {
        log.showInfo(`updateChainAniParams error in index = ${i},key is undefined`);
        return;
      }
      const ntfAnimationParam = this.ntfAnimationParas.get(key);
      // 如果在通知卡片不在可见的通知列表之内，则不执行链式动画
      if (i < this.firstIndex - 1 || i > this.lastIndex + 1) {
        continue;
      }
      if (!ntfAnimationParam || ntfAnimationParam.ntfItemTranslateY === ntfAnimationParam.templateTranslateY) {
        continue;
      }
      // 删除的是最后一个组通知中的单通知，不执行链式动画
      if (index === i && index === this.lastIndex && this.deleteNtfInfo?.groupKey === key) {
        ntfAnimationParam.ntfItemTranslateY = ntfAnimationParam.templateTranslateY || 0;
        continue;
      }
      animateTo({
        curve: Curve.Friction,
        duration: 350,
        delay: i < index ? Math.abs(index - i - 1) * 16.67 : Math.abs(index - i) * 16.67,
      }, () => {
        ntfAnimationParam.ntfItemTranslateY = ntfAnimationParam.templateTranslateY || 0;
      })
    }
  }

  private onUpdateDataFinish() {
    this.handleAnimationFinish();
    // 规避因onReachEnd问题导致不能滑动
    this.listScroller?.setReachEnd(false);
    this.isNtfListChanging = false;
    this.edgeEffect = EdgeEffect.Spring;
    this.ntfAnimVM?.clear();
    this.emptyListTipOpacity = this.getIsShowNtfEmptyTips() ? 1 : 0;
  }

  private startUpdateNtfListReport(type?: NtfDataChangeType) {
    if (type === NtfDataChangeType.REMOVE) {
      performanceMonitor.begin('CLEAR_NT_ANI', performanceMonitor.ActionType.LAST_UP, 'cancel');
    }
  }

  private endUpdateNtfListReport(type?: NtfDataChangeType) {
    if (type === NtfDataChangeType.REMOVE) {
      performanceMonitor.end('CLEAR_NT_ANI');
    }
  }

  /**
   * 正在删除的通知item回调
   * 复写NtfCloseVM.NtfCloseCallback
   *
   * @param deletingItem 正在删除的通知
   */
  onDeletingItemChange(deletingItem: NotificationEntry | undefined): void {
    this.ntfAnimVM?.setDeletingItem(deletingItem);
  }

  /**
   * 是否正在清除全部通知状态回调
   * 复写NtfListVm.NtfListChangeCallback
   * 该回调函数为PC独有
   *
   * @param isClearingAll 是否正在清除所有通知
   */
  onClearingAllChange(isClearingAll: boolean): void {
    log.showDebug('onClearingAllChange isClearingAll:' + isClearingAll);
    this.ntfAnimVM?.setClearingAll(isClearingAll);
    if (isClearingAll) {
      // 一键清除所有通知
      this.ntfAnimVM?.updateClearAllAnimationParams(this.firstIndex, this.lastIndex, this.ntfList);
      let newNtfList = this.filterCanNotClearNtfList();
      this.onNtfListDataChange(newNtfList);
    }
  }

  /**
   * 过滤出不可清除的通知
   * @returns
   */
  private filterCanNotClearNtfList(): NotificationEntry[] {
    let result: NotificationEntry[] = [];
    for (const group of this.ntfList) {
      if (group.canClear()) {
        continue;
      }
      if (group.isGroup) {
        const allChildEntryNum = group.childrenEntry?.length;
        group.childrenEntry = group.childrenEntry?.filter((entry) =>!entry.canClear());
        const canNotClearChildEntryNum = group.childrenEntry?.length;
        // 一键删除时NotificationListItem未感知到group变化,这里主动通知
        if (allChildEntryNum !== canNotClearChildEntryNum) {
          group.notifyDataChanged();
        }
      }
      result.push(group);
    }
    return result;
  }

  private refreshNtfList(dataSource: Array<NotificationEntry>): void {
    this.edgeEffect = EdgeEffect.None;
    this.updateData(dataSource);
    this.onUpdateDataFinish();
  }

  /**
   * 通知List发生变化的回调
   *
   * @param dataSource 新的通知列表的数据
   */
  async onNtfListDataChange(dataSource: Array<NotificationEntry>, type ?: NtfDataChangeType): Promise<void> {
    log.showInfo(`onNtfListDataChange, length: ${dataSource.length}, deleteAnimSyncFlag: ${this.deleteAnimSyncFlag}`);
    let filterData: NotificationEntry[] = [];
    let isInEmergencyOrThermalSafeMode = getIsInEmergencyOrThermalSafeMode(this.deviceModeState);
    filterData = this.getFilterData(isInEmergencyOrThermalSafeMode, filterData, dataSource);
    if (this.deleteAnimSyncFlag) {
      this.deleteAnimSyncData = dataSource;
      return;
    }
    await this.updateDataInterceptor?.awaitInterrupt();
    if (type === NtfDataChangeType.BATCH_UPDATE) {
      this.refreshNtfList(isInEmergencyOrThermalSafeMode ? filterData : dataSource);
      return;
    }

    const isPanelDismissing = DropDownPanelManager.isPanelDismissing();
    const isPanelShowing = DropDownPanelManager.isPanelShowing();
    log.showInfo(`onNtfListDataChange, isPanelDismissing: ${isPanelDismissing}, isPanelShowing: ${isPanelShowing}`);
    // 面板收起过程中或者面板在后台不需要做动效，并且错峰执行。解决如下场景问题：1、解决一键删除时的性能问题  2、横幅通知与列表一起更新的性能问题
    if ((isPanelDismissing || !isPanelShowing) && !(this.ntfListVM?.isPc() && this.isNtfShow)) {
      setTimeout(() => {
        // 消息生成过程中不使用弹簧效果，防止滑动动效存在问题
        this.refreshNtfList(isInEmergencyOrThermalSafeMode ? filterData : dataSource);
      }, 200);
    } else {
      // 消息生成过程中不使用弹簧效果，防止滑动动效存在问题
      if (!this.isInClearAllTransition) {
        log.showInfo(`not use clearAllTransition`)
        this.startUpdateNtfListReport(type);
        animateTo({
          duration: this.ntfAnimVM?.getNtfListDataChangeDuration(),
          curve: Curve.Friction,
          iterations: 1,
          playMode: PlayMode.Normal,
          onFinish: () => {
            this.endUpdateNtfListReport(type);
            this.onUpdateDataFinish();
            if (this.isUpdatingData) {
              this.isUpdatingData = false;
              this.updatingItemKey = '';
              this.updateNtfZIndexParam();
              this.updateOutRangeNtfAnimationParas();
            }
          }
        }, () => {
          this.setUpdateItemIndexToTop(isInEmergencyOrThermalSafeMode ? filterData : dataSource);
          this.updateData(isInEmergencyOrThermalSafeMode ? filterData : dataSource, true);
        })
      } else {
        log.showInfo(`use clearAllTransition`)
        setTimeout(() => {
          // 消息生成过程中不使用弹簧效果，防止滑动动效存在问题
          this.refreshNtfList(isInEmergencyOrThermalSafeMode ? filterData : dataSource);
        }, 75);
      }
    }
  }

  private setUpdateItemIndexToTop(dataSource: Array<NotificationEntry>): void {
    const ntfListTemp = dataSource?.filter(entry => entry);
    if (!this.isNtfShow || ntfListTemp.length !== this.ntfList.length) {
      return;
    }
    for (let i = this.firstIndex; i <= this.lastIndex && i < ntfListTemp.length; i++) {
      if (ntfListTemp[i].getGroupTypeKey() && ntfListTemp[i].getGroupTypeKey() !== this.ntfList[i].getGroupTypeKey()) {
        //有更新，卡片需要上移，提高卡片层级
        this.getListItemModifier(ntfListTemp[i].getGroupTypeKey()).attribute?.zIndex(NTF_MAX_Z_INDEX);
        this.isUpdatingData = true;
        this.updatingItemKey = ntfListTemp[i].getGroupTypeKey();
        break;
      }
    }
  }

  private onNtfSwipeDeleteEvent = (event: NtfSwipeDeleteEvent): void => {
    if (event?.eventType === NtfSwipeDeleteEvent.EVENT_TYPE_START) {
      log.showDebug(`deleteAnimaSync start`);
      this.deleteAnimSyncFlag = true;
      this.requestNextAccessFocusWhenRemoveNtf(event);
      return;
    }
    log.showDebug(`deleteAnimaSync end`);
    this.deleteAnimSyncFlag = false;
    if (this.deleteAnimSyncData !== undefined) {
      this.onNtfListDataChange(this.deleteAnimSyncData, NtfDataChangeType.REMOVE);
      this.deleteAnimSyncData = undefined;
    }
  }

  private requestNextAccessFocusWhenRemoveNtf(event: NtfSwipeDeleteEvent): void {
    if (!AccessibilityUtil.isAccessibilityMode()) {
      return;
    }

    const entry = event.entry;
    if (!entry) {
      log.showWarn('requestNextAccessFocusWhenRemoveNtf error by empty entry');
      return;
    }

    const ntfListAccessibilityBuilder = (): ListContentAccessibility => {
      return new ListContentAccessibility(this.getMainNtfListWithMemory(), this.getExtraNtfListWithMemory(),
        this.isExtraNtfsCollapsed);
    }

    let nextAccCompId: string | undefined = undefined;

    try {
      if (event.inGroup) {
        nextAccCompId = new GroupAccessibility(entry.groupEntry!,
          ntfListAccessibilityBuilder).getNextFocusCompIdWhenRemoveSubNtf(entry.hashCode);
      } else {
        nextAccCompId = ntfListAccessibilityBuilder().getNextFocusCompIdWhenRemoveListItem(entry.getGroupTypeKey());
      }
    } catch (e) {
      log.showError('nextAccCompId Error :', e);
    }

    log.showInfo('requestNextAccessFocusWhenRemoveNtf to %{public}s', nextAccCompId);
    if (nextAccCompId) {
      setTimeout(() => {
        AccessibilityUtil.requestFocusAccessibility(nextAccCompId!);
      }, 100);
    }
  }

  private getFilterData(isInEmergencyOrThermalSafeMode: boolean, filterData: NotificationEntry[],
    dataSource: NotificationEntry[]) {
    if (isInEmergencyOrThermalSafeMode && this.emergencyInfoList.length > 0) {
      filterData = dataSource?.filter((item) => {
        return item?.isLiveType() || this.emergencyWhiteList.includes(item?.creatorBundleName);
      }) ?? [];
    }
    return filterData;
  }

  /**
   * 设置通知的圆角
   */
  setNtfListRadius(): void {
    log.showInfo(`NotificationListContent setNtfListRadius`);
    for (let index = 0; index < this.ntfList.length; index++) {
      let key = this.ntfList[index]?.getGroupTypeKey();
      if (CommonUtils.isInvalid(key)) {
        continue;
      }
      if (CommonUtils.isInvalid(this.borderRadiusMap.get(key))) {
        let radius: number = ResUtils.getNumber($r('app.float.ntf_list_content_border_radius'));
        this.updateRadius(key, radius);
      }
      if (!this.ntfAnimationParas.get(key)) {
        this.ntfAnimationParas.set(key, new NotificationAnimationParas(0, 0, 1, 1, 0));
      }
    }
    if (!this.ntfAnimationParas.get(NTF_EXTRA_CONTENT_BRIEF_ID)) {
      this.ntfAnimationParas.set(NTF_EXTRA_CONTENT_BRIEF_ID, new NotificationAnimationParas(0, 0, 1, 1, 0));
    }
  }

  /**
   * 更新圆角半径。当半径变化时通知更新。
   *
   * @param key groupKey
   * @param radius 半径
   */
  updateRadius(key: string, radius: number): void {
    if (this.borderRadiusMap.get(key) === radius) {
      return;
    }
    this.borderRadiusMap.set(key, radius);

    // 圆角半径变化，同步更新卡片动效
    this.radiusSyncState++;
    log.showInfo(`current radiusSyncState is ${this.radiusSyncState}， borderRadiusMap set key is ${key},
    radius is ${radius}`);
  }

  /**
   * Y轴位移回调
   * OnFollowTranChangeListener
   *
   * @param tranY 平移值
   */
  onFollowTranChange(tranY: number): void {
    if (tranY < 0) {
      log.showWarn(`onFollowTranChange(${tranY})`);
      return;
    }
    this.ntfFollowTranY = tranY * 2;
    this.listFollowTranY = tranY * LIST_TRAN_WEIGHT * 2;
    log.showInfo(`onFollowTranChange  : ${this.ntfFollowTranY} ${this.listFollowTranY}`);
    if (this.listFollowTranY === 0) {
      this.touchEndCheckAnim();
    } else if (this.listFollowTranY > 0) {
      this.setContentTranslateY(this.listFollowTranY * this.transYCoefficient);
    }
  }

  private setContentTranslateY(newValue: number) {
    log.showInfo(`setContentTranslateY start, translateY: ${newValue}`);
    const listLength: number = this.ntfListVM?.getNtfListAdapter().totalCount() as number;
    let translateYArrTemp: number[] = [];
    for (let i = 0; i < listLength; i++) {
      translateYArrTemp[i] = newValue * 0.05 * i;
    }
    this.translateYArr = translateYArrTemp;
  }

  private touchEndCheckAnim(): void {
    if (this.dropDownEvent.progress == 0) {
      return;
    }
    log.showInfo(`touchEndCheckAnim, progress: ${this.dropDownEvent.progress}`);
    if (this.clipParam && this.dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL) {
      this.clipParam = false;
      sDropDownPanelManager.isClearAll = false;
    }
    for (let i = 0; i < this.translateYArr.length; i++) {
      this.translateYArr[i] = 0;
    }
  }

  /**
   * Y轴位移动画
   * OnFollowTranChangeListener
   *
   * @param tranAnim 动画
   */
  onFollowTranAnimChange(tranAnim: AnimateParam): void {
    this.ntfFollowAnim = tranAnim;
  }

  onScreenOrientationChanged(): void {
    log.showInfo('onScreenOrientationChanged isDisplayLand: ' + this.isDisplayLand);
    // 屏幕旋转，重新计算list剩余高度
    this.calculateNtfListHeight();
  }

  getNtfListRowRectInfo(): RectInfo {
    let rect = this.getRectInfoById(NotificationConstants.NTF_LIST_ROW_ID);
    return rect;
  }

  initOtherNtfPara(index: number) {
    if (index === this.mainNtfList?.length + 1) {
      return;
    }
    let key = this.getListItemKey(index);
    if (key == null) {
      return;
    }
    let rectInfo: RectInfo = this.getRectInfoById(key);
    let ntfAnimationParam = this.ntfAnimationParas.get(key);
    if (!ntfAnimationParam) {
      const newNtfAnimationParam = new NotificationAnimationParas(0, 0, 1, 1, 0);
      this.ntfAnimationParas.set(key, newNtfAnimationParam);
      ntfAnimationParam = newNtfAnimationParam;
    }
    let diff = this.listRectInfo!.bottom - rectInfo?.bottom;
    const rectHeight = rectInfo?.height ?? 0;
    let positionYDiff: number = Math.min(diff, 0);
    let ratio: number = rectHeight === 0 ? 1 : Math.max(Math.abs(positionYDiff) / rectHeight, 1);
    ntfAnimationParam.ntfItemTranslateY = positionYDiff;
    ntfAnimationParam.clearAnimOpacity = Math.max(1 - ratio, 0);
    ntfAnimationParam.clearAnimScale =
      NTF_TRANSLATE_MIN_SCALE + (1 - NTF_TRANSLATE_MIN_SCALE) * Math.max(1 - ratio, 0);
    ntfAnimationParam.ntfItemRotateCenterY = '0%';
    if (key === NotificationConstants.NTF_CENTER_EXTRA_HEADER_COMP_ID) {
      log.showInfo('initOtherNtfPara, Header opacity:%{public}d, zIndex:%{public}d', ntfAnimationParam.clearAnimOpacity, ntfAnimationParam.ntfItemZIndex);
    }
    this.logWrongIndexInfo(key, rectInfo);
  }

  followTranItemAnim(isShow: boolean, isWithAnim: boolean, isDropDownPanelHide?: boolean): void {
    const listLength: number = this.ntfListVM?.getNtfListAdapter().totalCount() as number;

    // Update translate y
    this.setContentTranslateY(this.listFollowTranY * this.transYCoefficient);
    log.showInfo(`onFollowTranItemAnim is --listLength: ${listLength} -isShow-${isShow} -isWithAnim-${isWithAnim}`);
    if (isShow) {
      this.deleteNtfInfo?.reset();
      this.isClearAllEmptyShowTipsAnim = false;
      // listRect按原逻辑对应为list父组件rect
      this.listRectInfo = this.getNtfListRowRectInfo();
      NtfScrollAnimation.listRect = this.getNtfListRowRectInfo();
    }
    if (isWithAnim) {
      if (this.isNtfListEmpty && !this.isClearAllEmptyShowTipsAnim) {
        this.emptyListTipOpacityChange(this.isNtfShow, 0);
      }
    } else {
      if (this.isNtfListEmpty && !this.isClearAllEmptyShowTipsAnim) {
        this.emptyListTipOpacity = isShow ? 1 : 0;
      }
    }
    if (listLength == 0) {
      this.hasInitOpacity = true;
      Trace.end(Trace.CORE_METHOD_NTF_FOLLOW);
      log.showInfo('onFollowTranItemAnim: listLength = 0');
      return;
    }
    this.updateNtfZIndexParam();
    this.ntfListTranslate = !isShow ? 0 : ITEM_TRANSLATE_Y;

    // 依次执行动效
    if (isShow) {
      this.handleItemsAnim(listLength, isShow, isWithAnim);
    }

    // Handle switch from control center
    if (isShow && !this.isFromDeskTop()) {
      this.ntfListTranslate = isShow ? 0 : ITEM_TRANSLATE_Y;
    } else if (isWithAnim) {
      Trace.start(Trace.CORE_METHOD_NTF_FOLLOW);
      // 重置动效参数,防止拉下通知中心卡片闪动
      if (isShow) {
        this.ntfListVM?.getNtfAdapterList()?.forEach((ntf) => {
          if (SystemUICcmConfig.instance.isEnabledLive2) {
          } else {
            if (ntf.isLiveType()) {
              const progressVm = ProgressCardAnimVm.getInstanceByScene(ntf.childrenEntry![0].hashCode,
                LiveUseScene.SCENE_NTF_CENTER);
              const otherCardVm = OhterCardExtendAnimVm.getInstanceByScene(ntf.childrenEntry![0].hashCode,
                LiveUseScene.SCENE_NTF_CENTER);
              const begin = ProgressCardAnimVm.getInitialProgress(progressVm);

              progressVm?.setAnimation(begin);
              progressVm?.reset();
              otherCardVm?.reset();
            }
          }
        });
      }

      animateTo({
        duration: TRANSLATE_Y_DISAPPEAR_ANIMATION_DURATION,
        curve: isShow ? TRANSLATE_Y_APPEAR_ANIMATION_CURVE : TRANSLATE_Y_DISAPPEAR_ANIMATION_CURVE,
        iterations: 1,
        playMode: PlayMode.Normal,
        onFinish: () => {
          Trace.end(Trace.CORE_METHOD_NTF_FOLLOW);
          this.ntfListTranslate = isShow ? 0 : ITEM_TRANSLATE_Y;
          if (isShow) {
            this.ntfListVM?.getNtfAdapterList()?.forEach((ntf) => {
              if (ntf.isLiveType() && !SystemUICcmConfig.instance.isEnabledLive2) {
                const progressVm = ProgressCardAnimVm.getInstanceByScene(ntf.childrenEntry![0].hashCode,
                  LiveUseScene.SCENE_NTF_CENTER);
                const otherCardVm = OhterCardExtendAnimVm.getInstanceByScene(ntf.childrenEntry![0].hashCode,
                  LiveUseScene.SCENE_NTF_CENTER);

                progressVm?.startAnimation();
                otherCardVm?.startAnimation();
              }
            })
          }
        }
      }, () => {
        this.ntfListTranslate = 0;
      });
    } else {
      if (this.dropDownEvent.target === TargetPanel.NONE || isDropDownPanelHide) {
        this.hasInitOpacity = false;
      }
      this.ntfListTranslate = 0;
    }
    this.resetAnimationParas(isShow, isWithAnim);
  }

  private resetAnimationParas(isShow: boolean, isWithAnim: boolean): void {
    if (!isShow && !isWithAnim) {
      // 重置所有的动画属性
      this.ntfAnimationParas?.forEach((ntfAnimationParam, key) => {
        log.showInfo(`reset animation paras for ${key}`);
        ntfAnimationParam?.reset();
      })
    }
  }

  onFollowTranItemAnim(isShow: boolean, isWithAnim: boolean, isDropDownPanelHide?: boolean): void {
    this.isNtfShow = isShow;
    this.listHeadTranY = 0;
    if (isShow) {
      if (isWithAnim && this.isFromDeskTop()) {
        this.hasInitOpacity = false;
      }
      if (this.clipParam) {
        log.showWarn(`clipParam wrong, try fix`);
        this.clipParam = false;
        sDropDownPanelManager.isClearAll = false;
      }
      if (!isWithAnim) {
        this.isDropDownAniFin = true;
      }
      this.isDropDownPanel = true;
      // 下拉面板场景，延迟32ms，与其他动效错峰执行。
      setTimeout(() => {
        this.followTranItemAnim(isShow, isWithAnim);

        // 下拉时补偿执行NtfSwipeDeleteEnd的事件, 避免deleteAnimSyncFlag为true导致界面锁死
        let event = new NtfSwipeDeleteEvent();
        event.eventType = NtfSwipeDeleteEvent.EVENT_TYPE_END;
        this.onNtfSwipeDeleteEvent(event);
      }, APPEAR_DELAY);
    } else if (!this.ntfListVM?.freezeMap.get('clearAll')) {
      this.isDropDownPanel = false;
      // 收起下拉面板场景，延迟100ms，与其他动效错峰执行。
      setTimeout(() => {
        this.followTranItemAnim(isShow, isWithAnim, isDropDownPanelHide);
        this.swipeHashCode = '';
      }, 100);
    }
  }
  // 将通知卡片透明度置为0，避免下拉时卡片会出现又消失而导致闪烁
  private initFollowTranItemOpacity(isShow: boolean) {
    for (let index = 0; index <= this.lastIndex; index++) {
      let entry = this.ntfListVM?.getNtfListAdapter()?.getData(index);
      if (!entry) {
        continue;
      }
      let ntfAnimationParam = this.ntfAnimationParas.get(entry.getGroupTypeKey());
      if (!ntfAnimationParam) {
        const newNtfAnimationParam = new NotificationAnimationParas(0, 0, 0, 1, 1);
        this.ntfAnimationParas.set(entry.getGroupTypeKey(), newNtfAnimationParam);
        ntfAnimationParam = newNtfAnimationParam;
      }
      ntfAnimationParam.clearAnimOpacity = isShow ? 1 : 0;
    }
  }

  private handleItemsAnim(listLength: number, isShow: boolean, isWithAnim: boolean): void {
    if (!this.hasInitOpacity) {
      this.initFollowTranItemOpacity(false);
      this.hasInitOpacity = true;
      this.listScroller?.scrollToFirst();
    }

    for (let index = 0; index < listLength; index++) {
      if (index >= this.firstIndex && index <= this.lastIndex) {
        this.startNtfItemAnimByRow(isShow, isWithAnim, index);
        continue;
      }
      let entry = this.ntfListVM?.getNtfListAdapter()?.getData(index);
      if (entry == null) {
        log.showError(`Entry is null, index is ${index}`);
        continue;
      }
      const ntfAnimationParam = this.ntfAnimationParas.get(entry.getGroupTypeKey());
      if (ntfAnimationParam) {
        ntfAnimationParam.clearAnimOpacity = 0;
        ntfAnimationParam.clearAnimScale = isShow ? 1 : 0.93;
        ntfAnimationParam.ntfItemRotateAngels = 0;
        ntfAnimationParam.ntfItemTranslateY = 0;
        ntfAnimationParam.ntfItemTranslateX = 0;
      }
    }
  }

  private getClearNtfLastIndex(): number {
    const mainNtfLength = this.getMainNtfListWithMemory().length;
    let lastNtfIndex = this.lastIndex;
    // 如果包含了"更多通知的Header",则lastIndex减1。
    if (this.lastIndex === mainNtfLength || (this.firstIndex <= mainNtfLength && this.lastIndex > mainNtfLength)) {
      lastNtfIndex--;
    }

    lastNtfIndex = this.scrollState === ScrollState.Idle ? lastNtfIndex : lastNtfIndex + 1;

    return lastNtfIndex;
  }

  /**
   * 一键删除时设置待删除通知的索引，用于卡片动效
   */
  private createClearAllNtfTransitionIndexMap() {
    const firstIndex = this.firstIndex;
    const lastIndex = this.getClearNtfLastIndex();

    for (let i = firstIndex; i <= lastIndex; i++) {
      const entry: NotificationEntry | undefined = this.ntfListVM?.getNtfListAdapter().getData(i);
      if (entry) {
        this.clearAllNtfIndexMap.set(entry, i)
      }
    }
  }

  onClearAllAnim(): void {
    const listLength: number = this.ntfListVM?.getNtfListAdapter().totalCount() as number;
    log.showInfo(`onClearAllAnim is --listLength: ${listLength} `);
    if (listLength == 0) {
      return;
    }
    this.isClearAllEmptyShowTipsAnim = true;
    this.clearAllFlag = true;
    this.clipParam = true;
    sDropDownPanelManager.isClearAll = true;

    // 是否使用transition转场动效。这种场景下直接删除通知触发动效，节省功耗。
    const useTransition: boolean = this.useClearAllTransition();

    // 执行一键删除动效（使用transition转场时，里面只处理垃圾桶动效。否则会一并处理卡片动效）
    this.startClearAllAnimation(useTransition);

    // 卡片一键删除动效时长
    const cardAnimateDuration = this.getClearAllCardAnimateDuration();

    // 使用transition处理卡片动效
    if (useTransition) {
      this.createClearAllNtfTransitionIndexMap();
      this.isInClearAllTransition = true;

      // 卡片删除且transition动效时长结束后，收起面板
      setTimeout(() => {
        this.ntfListVM?.hidePanelByClearNtf(0);
        this.clearAllNtfIndexMap.clear();
        this.isInClearAllTransition = false;
        this.isShowNtfEmptyTips = this.getIsShowNtfEmptyTips();
        log.showInfo(`hide panel finish, reset isShowNtfEmptyTips = ${this.isShowNtfEmptyTips}`);
      }, cardAnimateDuration);

      // 删除通知
      this.ntfListVM?.clearAllNtf(0, false);
      return;
    }

    // 使用animateTo处理卡片动效
    setTimeout(() => {
      this.ntfListVM?.clearAllNtf(0);
    }, cardAnimateDuration);
  }

  private useClearAllTransition(): boolean {
    if (this.ntfClearAllAnimation?.useTransition !== true) {
      return false;
    }

    if (this.isScrolling || (this.scrollState !== ScrollState.Idle)) {
      return false;
    }

    if (!this.isDropDownAniFin) {
      return false;
    }

    if (this.extraNtfList.length > 0) {
      return false;
    }

    const notUseTransition = this.mainNtfList.some((entry => {
      const isGroup: boolean = entry?.isGroup && (entry?.childrenEntry?.length ?? 0) > 1;
      const isLive: boolean = entry?.isLiveType();
      const isRemoveNotAllowed: boolean = !entry?.canClear();
      return isGroup || isLive || isRemoveNotAllowed;
    }));

    if (notUseTransition) {
      return false;
    }

    const isEnabledLive2: boolean = SystemUICcmConfig.instance.isEnabledLive2;
    const currentNtfCount: number =
      isEnabledLive2 ? NotificationDataManager.instance.ntfMap.size : ntfListener.getCurrentNtfCount();

    if (currentNtfCount !== 5) {
      return false;
    }

    log.showInfo(`satisfy all conditions, use transitionEffect`)
    return true;
  }

  /**
   * 一键删除场景，所有卡片消失的动效时间。不包含通知面板收起。
   * @returns
   */
  private getClearAllCardAnimateDuration() {
    return 100 + (this.getClearNtfLastIndex() - this.firstIndex - 1) * NtfClearAllAnimation.delayPerItem +
    NtfClearAllAnimation.clearButtonAniDuration;
  }

  private startClearAllAnimation(useTransition: boolean = false): void {
    // 设置动效
    const firstIndex: number = this.firstIndex > this.mainNtfList?.length ? this.firstIndex - 1 : this.firstIndex;
    this.ntfClearAllAnimation?.init(firstIndex, this.getClearNtfLastIndex(), this.ntfAnimationParas,
     useTransition);
    // 执行动效
    this.ntfClearAllAnimation?.startAnimation().then(() => this.onAnimationFinish());
  }

  onNtfEmptyListChange(): void {
    log.showInfo(`onNtfEmptyListChange isNtfListEmpty: ${this.isNtfListEmpty} isNtfShow: ${this.isNtfShow}`);
    if (!this.isClearAllEmptyShowTipsAnim) {
      this.emptyListTipOpacityChange(this.isNtfListEmpty && this.isNtfShow, 0);
      this.isShowNtfEmptyTips = this.getIsShowNtfEmptyTips();
    }
  }

  emptyListTipOpacityChange(isShow: boolean, delay: number): void {
    log.showInfo(`emptyListTipOpacityChange isShow: ${isShow} delay: ${delay}`);
    this.emptyListTipOpacity = isShow ? 0 : 1;

    if (DropDownPanelManager.isPanelDismissing() || !DropDownPanelManager.isPanelShowing()) {
      this.emptyListTipOpacity = isShow ? 1 : 0;
      this.isClearAllEmptyShowTipsAnim = false;
    } else {
      animateTo({
        duration: isShow ? 250 : 50, // 动画时长
        curve: Curve.Friction, // 动画曲线
        delay: isShow ? delay : 32, // 动画延迟
        iterations: 1, // 播放次数
        playMode: PlayMode.Normal, // 动画模式
        onFinish: () => {
          this.isClearAllEmptyShowTipsAnim = false;
        }
      }, () => {
        this.emptyListTipOpacity = isShow ? 1 : 0;
      })
    }

  }

  /**
   * 获取 收起状态下更多通知简介集合 ListItem的index
   * @returns -1:不存在更多通知或者更多通知处于展开态, 其他:index
   */
  getExtraContentBriefIndex(): number {
    if (this.showExtraNtfsCollapsed()) {
      return this.mainNtfList?.length + 1;
    }
    // 更多通知处于展开态
    return -1;
  }

  /**
   * 获取 更多通知标题 ListItem的index
   * @returns -1:不存在更多通知, 其他:index
   */
  getExtraHeaderIndex(): number {
    if (this.extraNtfList?.length > 0) {
      return this.mainNtfList?.length;
    }
    return -1;
  }

  updateBottomNtfAnimationParas(): void {
    const lastIndex = this.getLastIndex();
    if (NotificationConstants.NTF_CENTER_EXTRA_HEADER_COMP_ID === this.getListItemKey(lastIndex)) {
      this.updateTopOrBottomNtfAnimationParas(false, lastIndex + 1, true);
    } else {
      this.updateTopOrBottomNtfAnimationParas(false, lastIndex);
    }
  }

  /**
   * 根据在list中的index去获取每个listItem的key
   * @param index
   * @returns key
   */
  getListItemKey(index: number): string | undefined {
    let maxIndex = this.getMaxIndex();
    if (index < 0 || index > maxIndex ||
      (this.showExtraNtfsCollapsed() && (index > this.mainNtfList?.length + (this.isShowBottomTransCard ? 2 : 1)))) {
      return undefined;
    }
    if (index < this.mainNtfList?.length) {
      return this.mainNtfList[index]?.getGroupTypeKey();
    }
    if (index === this.getExtraHeaderIndex()) {
      return NotificationConstants.NTF_CENTER_EXTRA_HEADER_COMP_ID;
    }
    if (index === this.getExtraContentBriefIndex()) {
      return NTF_EXTRA_CONTENT_BRIEF_ID;
    }
    if (this.isShowBottomTransCard && (index === maxIndex)) {
      return TRANSPARENT_CARD_ID
    }
    return this.extraNtfList[index - this.mainNtfList?.length - 1]?.getGroupTypeKey();
  }

  getRectInfoById(id: string): RectInfo {
    return ItemUtils.getRectById(id);
  }

  getNtfMaxHeightThreshold(index: number): number {
    return this.mainNtfList[index]?.isLiveType() ? NotificationConstants.LIVE_VIEW_MAX_HEIGHT_THRESHOLD :
    NotificationConstants.NTF_MAX_HEIGHT_THRESHOLD;
  }

  convertToRect(listRectInfo: RectInfo, rectResult: RectResult): RectInfo {
      let rect: RectInfo = new RectInfo();
      rect.left = listRectInfo.left;
      rect.top = rectResult.y + listRectInfo.top;
      rect.right = listRectInfo.right;
      rect.bottom = rectResult.height + rect.top;
      rect.height = rectResult.height;
      rect.width = rectResult.width;

      return rect;
  }

  updateTopOrBottomNtfAnimationParas(isTop: boolean, index: number, isExtraHead?: boolean): void {
    if (!this.isEnableScrollAnimation) {
      return;
    }
    let groupKey: string | undefined = this.getListItemKey(index);
    if (groupKey == null) {
      log.showWarn(`updateTopOrBottomNtfAnimationParas key error, index = ${index}, key = ${groupKey}, isExtraHead:${isExtraHead}`);
      return;
    }
    let rectResult: RectResult | undefined = this.listScroller?.getScroller().getItemRect(index);
    if (!this.listRectInfo) {
      this.listRectInfo = this.getNtfListRowRectInfo();
      NtfScrollAnimation.listRect = this.getNtfListRowRectInfo();
    }
    let rectInfo: RectInfo;
    if (isExtraHead || !rectResult?.height) {
      // 可视区域外rectResult无法获取到height
      rectInfo = this.getRectInfoById(groupKey);
      if (rectInfo.width === 0 && rectInfo.height === 0) {
        // 获取通知卡片rect异常, 跳过本次动效参数的更新
        log.showWarn(`updateTopOrBottomNtfAnimationParas index:${index} groupKey:${groupKey} getRectInfoById failed!`);
        return;
      }
    } else {
      rectInfo = this.convertToRect(this.listRectInfo, rectResult);
    }
    let ntfAnimationParam = this.ntfAnimationParas.get(groupKey);
    if (!ntfAnimationParam) {
      const newNtfAnimationParam = new NotificationAnimationParas(0, 0, 1, 1, 0);
      this.ntfAnimationParas.set(groupKey, newNtfAnimationParam);
      ntfAnimationParam = newNtfAnimationParam;
    }

    // 卡片开启倾斜的最大高度阈值
    let maxHeight = this.getNtfMaxHeightThreshold(index);
    // 卡片真实高度
    let realHeight = rectInfo?.height ?? 0;
    let positionYDiff: number = 0;
    // 删除时所取的卡片位置仍处于之前的位置，需要手动更新补位位置，即移动删除卡片的高度
    let rectInfoOffset = this.getChainOffset(isTop);
    // 链式动效的补位位移
    let endOffset = this.getChainOffset(isTop, true);
    // 顶部卡片
    if (isTop) {
      endOffset = -1 * endOffset;
      // 高度超出阈值，待可见高度到阈值时开启倾斜
      if (realHeight > maxHeight) {
        positionYDiff = Math.max(maxHeight - (rectInfo?.bottom - this.listRectInfo!.top), 0);
      } else { // 高度阈值内，直接开启倾斜
        positionYDiff = Math.max(this.listRectInfo!.top - rectInfo?.top, 0);
      }
    } else { // 底部卡片
      // 高度超出阈值，待可见高度到阈值时开启倾斜
      let virBottom = this.getVirBottom(rectInfo, realHeight, maxHeight, this.listRectInfo!, groupKey)
      let isExtraID = this.lastIndex === (this.mainNtfList.length + 1) && this.lastIndex !== this.getMaxIndex()
      if (rectInfo?.top <= this.listRectInfo!.bottom ||
        (this.deleteNtfInfo?.realHeight && this.deleteNtfInfo?.realHeight <= realHeight) || isExtraID) {
        rectInfoOffset = 0;
      }
      let diff = virBottom + rectInfoOffset;
      positionYDiff = Math.min(diff, 0);
    }
    positionYDiff = this.ntfScrollAnimation?.getCorrectPositionYDiff(this.itemScrollOffset,
      ntfAnimationParam, positionYDiff) ?? positionYDiff;
    if (realHeight !== 0 && ntfAnimationParam?.realHeight !== realHeight) {
      ntfAnimationParam.realHeight = realHeight;
    }
    // 卡片倾斜进度值，大于0为有效值
    let ratio: number = this.getRatio(positionYDiff, realHeight, maxHeight, groupKey);
    // 当通知中心卡片列表为平铺效果时，ratio始终为0
    if (!this.listContentConfig.isNtfListFold) {
      ratio = 0;
    }
    const opacityRatio = this.getOpacityRatio(ratio);
    log.showDebug(`updateAnimationParam , ratio: ${ratio}, realHeight: ${realHeight}, rectInfo.bottom: ${rectInfo
    ?.bottom}, rectInfo.top: ${rectInfo?.top}, listRectInfo.bottom: ${this.listRectInfo!.bottom}`);
    if (ratio > 0) {
      ntfAnimationParam.templateTranslateY = positionYDiff;
      positionYDiff += endOffset;
      this.setItemAnimationParas(groupKey, positionYDiff, ratio, isTop, opacityRatio);
      this.logWrongIndexInfo(groupKey, rectInfo);
    } else if (!this.clipParam) {
      ntfAnimationParam.templateTranslateY = 0;
      ntfAnimationParam?.reset(endOffset);
      if (realHeight > maxHeight) {
        this.setClipParam(isTop, rectInfo, groupKey);
      }
    }
  }
  // 获取补位时需要手动更新的位置
  getChainOffset(isTop: boolean, isEndOffSet: boolean = false): number {
    if (!this.deleteNtfInfo || !this.deleteNtfInfo.entry) {
      return 0
    }
    let rectInfoOffset = this.deleteNtfInfo?.realHeight;
    if (rectInfoOffset > CHAIN_MAX_OFFSET) {
      rectInfoOffset = isEndOffSet ? CHAIN_MAX_OFFSET : rectInfoOffset;
    }
    switch (this.chainDirection) {
      case 'middle': return isTop ? 0 : 0.2 * rectInfoOffset;
      case 'top': return isTop ? rectInfoOffset : 0;
      case 'bottom': return isTop ? 0 : rectInfoOffset;
      default: return 0;
    }
  }
  setClipParam(isTop: boolean, rectInfo: RectInfo, groupKey: string) {
    if (!this.listRectInfo) {
      return;
    }
    let clipHeight = 0;
    let offsetY = 0;
    if (this.firstIndex === this.lastIndex) {
      // 全屏只有一张卡片，且超过屏幕高度,需要裁切上下圆角
      clipHeight = this.listRectInfo.bottom - this.listRectInfo.top;
      offsetY = this.listRectInfo.top - rectInfo.top;
    } else {
      clipHeight = isTop ? rectInfo.bottom - this.listRectInfo.top :
        this.listRectInfo!.bottom - rectInfo.top;
      offsetY = isTop ? this.listRectInfo.top - rectInfo.top : 0;
    }
    const ntfAnimationParam = this.ntfAnimationParas.get(groupKey);
    ntfAnimationParam?.updateClipHeight(clipHeight);
    ntfAnimationParam?.updateClipOffsetY(offsetY);
  }
  getVirBottom(rectInfo: RectInfo, realHeight: number, maxHeight: number, listRectInfoRow: RectInfo, groupKey: string) {
    // 手机底部有间距，PAD底部无间距
    const listBottom = listRectInfoRow?.bottom;
    const rectTop = realHeight === 0 ? listBottom : (rectInfo?.top ?? 0)
    let virBottom =
      realHeight === 0 ? rectTop + (this.ntfAnimationParas.get(groupKey)?.realHeight ?? 0) : (rectInfo?.bottom ?? 0);
    if (realHeight > maxHeight) {
      virBottom = rectTop + maxHeight;
    }
    return listBottom - virBottom
  }

  setItemAnimationParas(groupKey: string, positionYDiff: number, ratio: number, isTop: boolean, opacityRatio: number) {
    const ntfAnimationParam = this.ntfAnimationParas.get(groupKey);
    if (ntfAnimationParam) {
      ntfAnimationParam.ntfItemTranslateY = positionYDiff;
      ntfAnimationParam.clearAnimOpacity = Math.max(1 - opacityRatio, 0);
      ntfAnimationParam.clearAnimScale =
        NTF_TRANSLATE_MIN_SCALE + (1 - NTF_TRANSLATE_MIN_SCALE) * Math.max(1 - ratio, 0);
      ntfAnimationParam.ntfItemRotateCenterY = isTop ? '100%' : '0%';
      ntfAnimationParam.ntfItemClipHeight = -1;
      ntfAnimationParam.ntfItemClipOffsetY = 0;
    }
  }
    /**
   * 更新通知zIndex, 解决底部通知层级问题
   */
  updateNtfZIndexParam = (): void => {
    const lastIndex = this.getLastIndex();
    for (let index = this.firstIndex + 1; index < lastIndex; index++) {
      let key = this.getListItemKey(index);
      if (this.isUpdateZIndex(key) && key != undefined) {
        // 调整卡片层级,使卡片从上到下依次展开
        const negIndex = Math.abs(index - lastIndex)
        // zIndex无动效变化，在一屏实况卡片删除时，底部卡片补位时层级会直接增加导致处于上一卡片的上部分
        this.getListItemModifier(key).attribute?.zIndex(negIndex);
      }
    }

    // 顶部卡片
    this.updateItemZIndex(this.firstIndex);
    // 底部卡片
    this.updateItemZIndex(lastIndex);
    if (this.isUpdatingData) {
      return;
    }
    const lastKey = this.getListItemKey(this.lastIndex + 1);
    const ntfAnimationParam = lastKey !== undefined ? this.ntfAnimationParas.get(lastKey) : undefined;
    if (ntfAnimationParam !== undefined) {
      ntfAnimationParam.clearAnimOpacity = 0;
    }
  }

  private isUpdateZIndex(key: string | undefined): boolean {
    return !(this.isUpdatingData && this.updatingItemKey === key &&
      this.ntfAnimationParas.get(key)?.clearAnimOpacity === 1);
  }

  private updateItemZIndex(index: number): void {
    const key = this.getListItemKey(index);
    if (this.isUpdateZIndex(key) && key != undefined) {
      const zIndex = this.ntfAnimationParas.get(key)?.clearAnimOpacity != 1 ? -1 : 0;
      this.getListItemModifier(key).attribute?.zIndex(zIndex);
    }
  }

  maximizesZIndex = (key: string): void => {
    this.getListItemModifier(key).attribute?.zIndex(Number.MAX_SAFE_INTEGER);
  }

  getChainAnimDirection(lastIndex: number = this.lastIndex): string {
    let key = this.getListItemKey(this.firstIndex);
    const maxIndex = this.getMaxIndex();
    if (!key) {
      return 'bottom';
    }
    const ntfAnimationParam = this.ntfAnimationParas.get(key);
    let isClipTop = true;
    if (ntfAnimationParam) {
      isClipTop = Math.round(ntfAnimationParam.ntfItemTranslateY) !== 0;
    }
    let isClipBottom = this.checkIsAnimating(lastIndex);
    if ((isClipTop || this.firstIndex !== 0) && lastIndex === maxIndex && !isClipBottom) {
      // 首张卡片处于堆叠态，或index=0的卡片被隐藏到上面，同时底部已经触底时，删除卡片为上分区补位(超一屏）
      return 'top';
    } else if ((isClipTop || this.firstIndex !== 0) && (lastIndex === maxIndex && isClipBottom)) {
      // 超一屏且滑动至底部最后一张卡片堆叠时，为上下一起补位
      return 'middle';
    } else {
      return 'bottom';
    }
  }
  updateMiddleNtfAnimationParas(): void {
    let delIndex = this.deleteNtfInfo?.index;
    for (let index = this.firstIndex; index < this.lastIndex; index++) {
      let key = this.getListItemKey(index);
      if (key != undefined) {
        let endOffset = 0;
        if (delIndex !== undefined && delIndex >= 0) {
          endOffset = this.getEndOff(index, delIndex)
        }
        let rectResult: RectResult | undefined = this.listScroller?.getScroller().getItemRect(index);
        if (!this.listRectInfo) {
          this.listRectInfo = this.getNtfListRowRectInfo();
          NtfScrollAnimation.listRect = this.getNtfListRowRectInfo();
        }
        let rectInfo: RectInfo = rectResult ? this.convertToRect(this.listRectInfo, rectResult)
          : this.getRectInfoById(key);

        let realHeight = rectInfo?.height ?? 0;
        let ntfAnimationParam = this.ntfAnimationParas.get(key);
        if (!ntfAnimationParam) {
          const newNtfAnimationParam = new NotificationAnimationParas(0, endOffset, 1, 1, 0);
          this.ntfAnimationParas.set(key, newNtfAnimationParam);
          newNtfAnimationParam.templateTranslateY = 0;
          ntfAnimationParam = newNtfAnimationParam;
        } else {
          ntfAnimationParam?.reset(endOffset);
          ntfAnimationParam.templateTranslateY = 0;
        }
        ntfAnimationParam.realHeight = realHeight;
      } else {
        log.showError(`The middle ntf is not exist, index is ${index}`);
      }
    }
  }
  getEndOff(index: number, delIndex: number): number {
    if (!this.deleteNtfInfo?.realHeight) {
      return 0;
    }
    let offset = this.chainDirection === 'middle' ? this.deleteNtfInfo?.realHeight * 0.2 : this.deleteNtfInfo?.realHeight;
    // 超一屏展开组通知删除组通知时会跳变
    offset = offset > CHAIN_MAX_OFFSET ? CHAIN_MAX_OFFSET : offset;
    if (this.chainDirection === 'top') {
      // 顶部堆叠时在顶部加入链式动效
      return index < (delIndex - 1) ? -offset * 0.5 : 0;
    } else if (this.chainDirection === 'middle') {
      return index <= delIndex ? 0 : offset;
    } else {
      return index <= delIndex ? 0 : offset;
    }
  }
  /**
   * 更新通知仿射变换参数
   *
   * @param isSlipUp是否上滑场景
   */
  updateNtfAnimationParas(isSlipUp: boolean = false): void {
    if (!this.isEnableScrollAnimation || this.clipParam) {
      log.showWarn(`updateNtfAnimationParas skip update anim paras`);
      return;
    }
    // 上滑场景需要判断是否已完全显示
    this.updateMiddleNtfAnimationParas();
    if (!isSlipUp || !this.isLastNtfAnimationUpdatedFinished()) {
      this.updateBottomNtfAnimationParas();
    }
    this.updateNtfZIndexParam();
    if (this.deleteNtfInfo?.entry) {
      // 删除场景添加链式动效
      this.updateChainAniParams(this.deleteNtfInfo.index);
      this.deleteNtfInfo?.reset();
    }

    // 更新firstIndex前和lastIndex后的通知卡片的动效参数
    this.updateOutRangeNtfAnimationParas();
  }

  /**
   * 重置某个通知卡片的动效参数
   * @param index
   */
  resetNtfItemAnimationParas(index: number, resetOpacity: boolean = false) {
    let groupKey: string | undefined = this.getListItemKey(index);
    if (groupKey == null) {
      return;
    }

    let ntfAnimationParam = this.ntfAnimationParas.get(groupKey);
    if (ntfAnimationParam) {
      ntfAnimationParam.templateTranslateY = 0;
      ntfAnimationParam.ntfItemTranslateY = 0;
      if (resetOpacity) {
        ntfAnimationParam.clearAnimOpacity = 0;
      }
    }
  }
  /**
   * 更新firstIndex和lastIndex之外卡片的动效参数
   */
  updateOutRangeNtfAnimationParas(): void {
    if (this.isUpdatingData) {
      return;
    }
    // 重置firstIndex之前通知卡片的动效参数
    for (let index = 0; index < this.firstIndex; index++) {
      this.resetNtfItemAnimationParas(index, true);
    }

    // 重置lastIndex之后通知卡片的动效参数
    let lastIndex = this.lastIndex;
    if (NotificationConstants.NTF_CENTER_EXTRA_HEADER_COMP_ID === this.getListItemKey(lastIndex)) {
      lastIndex++;
    }
    for (let index = lastIndex + 1; index <= this.getMaxIndex(); index++) {
      this.resetNtfItemAnimationParas(index, true);
    }
  }

  updateNtfAnimationParasWithAnimate() {
    if (!this.isEnableScrollAnimation) {
      return;
    }
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 22),
      delay: 0, // 动画延迟
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
      onFinish: () => {
      }
    }, () => {
      this.updateNtfAnimationParas();
    })
  }

  private shouldUpdateNtfAnimationOnAreaChange(oldHeight: Length, newHeight: Length) {
    if (!this.isNtfShow) {
      return false;
    }
    let notScrolling: boolean = !this.isScrolling || (this.scrollState === ScrollState.Idle);
    // 静止状态下或组通知展开通知有变化或者通知高度变化
    return (notScrolling || this.isGroupExpanding) && (this.isNtfListChanging || (oldHeight !== newHeight)) &&
      !this.listScroller?.isReachEnd;
  }

  initDeleteInfo(dataSource: Array<NotificationEntry>, item:NotificationEntry, heightDiff: number = 0) {
    let key = item?.getGroupTypeKey()
    if (!key) {
      return;
    }
    let index = dataSource.findIndex(entry => entry.getGroupTypeKey() === key);
    if (item?.isExtraContentType()) {
      index++;
    };
    if (index < this.firstIndex || index > this.lastIndex) {
      this.deleteNtfInfo?.reset();
      return;
    }
    let deleteAniParas = this.ntfAnimationParas.get(key);
    let realHeight = heightDiff ? heightDiff : (deleteAniParas?.realHeight || 0);
    this.deleteNtfInfo = new DeleteNtfInfo(item, index, realHeight);
    this.chainDirection = this.getChainAnimDirection(this.lastIndex);
    log.showInfo(`chainDirection:${this.chainDirection}, ${this.firstIndex}, ${this.lastIndex}}`)
    if (this.chainDirection !== 'bottom') {
      /**
       * 上分区场景堆叠且上分区补位时，firstIndex需要计算将补位的高度判断index
       */
      let num = this.calculateDiffHeight(true, this.firstIndex, realHeight);
      this.firstIndex = (this.firstIndex - num) < 0 ? 0 : (this.firstIndex - num);
    } else {
      let num = this.calculateDiffHeight(false, this.lastIndex, realHeight);
      this.lastIndex = (this.lastIndex + num) > this.getMaxIndex() ? this.getMaxIndex() : (this.lastIndex + num);
    }
  }
  calculateDiffHeight(isTop: boolean, index: number, delHeight: number) {
    let sIndex = isTop ? index + 1 : index - 1
    let groupKey: string | undefined = this.getListItemKey(sIndex);
    if (!groupKey) {
      return 0;
    }
    let rectInfo: RectInfo = this.getRectInfoById(groupKey);
    let cardHeight = this.getListItemHeightByIndex(index);
    let diff = isTop ? rectInfo.top - this.listRectInfo!.top + delHeight :
      this.listRectInfo!.bottom - rectInfo.bottom + delHeight
    return diff > cardHeight ? Math.max((Math.floor(diff / (cardHeight + 16)) - 1), 0) : 0;
  }
  getListItemHeightByIndex(index:number): number {
    let groupKey: string | undefined = this.getListItemKey(index);
    if (groupKey == null) {
      log.showWarn(`getListItemHeightByIndex error, index = ${index}, key = ${groupKey}`)
      return 0;
    }
    let rectInfo: RectInfo = this.getRectInfoById(groupKey);
    return rectInfo.height || 0
  }
  onListItemSizeChange(oldValue: SizeOptions, newValue: SizeOptions, entry: NotificationEntry) {
    if (CommonUtils.isInvalid(entry) || !DropDownPanelManager.isPanelShowing() || !this.isDropDownAniFin) {
      return;
    }
    this.ntfAnimVM?.setNtfHeightParams(entry?.getGroupTypeKey(), Number(newValue.height))

    // 组件高度变化更新是否触底
    if (newValue.height != oldValue.height) {
      this.refreshListReachEnd();
    }
    if (this.shouldUpdateNtfAnimationOnAreaChange(oldValue.height ?? 0, newValue.height ?? 0)) {
      if (newValue.height && oldValue.height && newValue.height < oldValue.height) {
        // 高度变小，链式补位动效
        let heightDiff = Number(oldValue.height) - Number(newValue.height);
        if (heightDiff > 30 && heightDiff < 80) {
          // 区分组通知、更多通知展开折叠的场景
          this.initDeleteInfo(this.ntfList, entry, heightDiff)
        }
      }
      log.showInfo(`Item size change, hashCode is ${entry?.getGroupTypeKey()}, height is ${newValue?.height}`);
      this.updateNtfAnimationParasWithAnimate();
    }
  }

  /**
   * 刷新触底变量，防止组通知展开无法继续下滑
   */
  refreshListReachEnd(): void {
    if (this.listScroller?.isReachEnd) {
      if (this.lastIndex != this.getMaxIndex()) {
        this.listScroller?.setReachEnd(false);
        this.isAlreadyReachEnd = false;
        return;
      } else {
        let groupKey: string | undefined = this.getListItemKey(this.getMaxIndex());
        if (groupKey == undefined) {
          return;
        }
        let rect = ItemUtils.getRectById(groupKey);
        if (rect == null) {
          return;
        }
        if (rect.bottom > this.ntfAreaRect.bottom) {
          this.listScroller?.setReachEnd(false);
          this.isAlreadyReachEnd = false;
        }
      }
    }
  }

  private getPCTransition(entry: NotificationEntry): TransitionEffect | undefined {
    return this.ntfAnimVM?.getNtfListItemTransition(entry);
  }

  private getClearAllTrans(entry: NotificationEntry): TransitionEffect | undefined {
    if (!this.ntfClearAllAnimation) {
      return;
    }

    const index = this.clearAllNtfIndexMap.get(entry);
    if (index === undefined) {
      return;
    }

    return TransitionEffect.asymmetric(this.ntfAnimVM?.getNtfAppearTransition(),
      this.ntfAnimVM?.getNtfClearAllTransition(entry, this.ntfClearAllAnimation, index, this.firstIndex,
        this.getClearNtfLastIndex()));
  }

  private getMainTransition(entry: NotificationEntry): TransitionEffect | undefined {
    // 一键删除过程中时，使用对应的转场动效
    if (this.isInClearAllTransition) {
      const clearAllTrans = this.getClearAllTrans(entry);
      if (clearAllTrans) {
        return clearAllTrans;
      }
    }

    if (this.ntfListVM?.isPc()) {
      return this.getPCTransition(entry);
    }
    return NtfDropdownController.isVisible() ? this.mainNtfAnimation : undefined;
  }

  private getExtraTransition(entry: NotificationEntry): TransitionEffect | undefined {
    if (!DeviceHelper.isPC() && !this.isDropDownAniFin) {
      return undefined;
    }
    return this.extraNtfsTransitionAnimations[this.getNtfIndex(entry)];
  }

  private changeNtfAreaRect(newValue: Area): void {
    this.listArea = newValue;
    this.ntfAreaRect.top = Number(newValue.globalPosition.y);
    this.ntfAreaRect.bottom = Number(newValue.globalPosition.y) + Number(newValue.height);
    this.ntfAreaRect.left = Number(newValue.globalPosition.x);
    this.ntfAreaRect.right = Number(newValue.globalPosition.x) + Number(newValue.width);
    this.ntfAreaRect.height = Number(newValue.height);
    if (this.ntfListVM) {
      this.ntfListVM.listContainerRect = this.ntfAreaRect;
    }
  }

  private getMainNtfListWithMemory(): Array<NotificationEntry> {
    const mainNtfs = this.trimMemory ? this.mainNtfList.slice(0, NTF_SHOW_NUM) : this.mainNtfList;
    this.extraNtfCollapsedAnimation.mainNtfs = mainNtfs;
    return mainNtfs;
  }

  private getExtraNtfListWithMemory(): Array<NotificationEntry> {
    const extraNtfs = this.trimMemory ? this.extraNtfList.slice(0, NTF_SHOW_NUM) : this.extraNtfList;
    this.extraNtfCollapsedAnimation.extraNtfs = extraNtfs;
    if (this.extraNtfList.length === 0) {
      return this.extraNtfList;
    }
    if (this.showExtraNtfsCollapsed()) {
      return this.extraBrief ? [this.extraBrief] : [this.extraNtfList[0]];
    }
    return extraNtfs;
  }

  private getClipPath() {
    const r = ArkUIAdapter.vp2px(ResUtils.getNumber($r('app.float.ntf_list_content_border_radius')));
    const width = ArkUIAdapter.vp2px(Number(this.listArea?.width));
    const heightClip = ArkUIAdapter.vp2px(Number(this.listArea?.height));
    const height = heightClip;
    const overWidth = ArkUIAdapter.vp2px(50);
    let commands = this.getClipPathCommands(r, width, height, overWidth);

    log.showInfo(`NTF List clip path commands=${commands.replace(/\n/g, ' ')}`);

    return new Path({ commands });
  }

  private getClipPathCommands(r: number, width: number, height: number, overWidth: number): string {
    let clipHeight = -height;
    if (DISABLE_HEAD_BLUR_EFFECT) {
      clipHeight = ResUtils.getNumber($r('app.float.status_bar_phone_height'));
      if (!this.isDisplayLand) {
        clipHeight += ResUtils.getNumber($r('app.float.ntf_title_padding_top'));
      }
      clipHeight = ArkUIAdapter.vp2px(clipHeight);
    }
    return `
      M0 ${clipHeight}
      L${width} ${clipHeight}
      L${width + overWidth} ${clipHeight}
      L${width + overWidth} ${height - r}
      L${width} ${height - r}
      A${r} ${r} 0 0 1 ${width - r} ${height}
      L${r} ${height}
      A${r} ${r} 0 0 1 0 ${height - r}
      L-${overWidth} ${height - r}
      L-${overWidth} ${clipHeight}
      L0 ${clipHeight}
      Z`;
  }


  /**
   * 因onClick事件会使控件强制能获取无障碍屏幕朗读的焦点，并且无法做到父节点无法选中而子节点能选中。
   * 如果在notificationList上添加onClick事件会导致在无障碍屏幕朗读时无法选中列表中内容，
   * 故为规避此问题在notificationList下面添加一层background用于单独处理onClick事件，并且设置成无障碍屏幕朗读不可选中。
   * 如若后面系统支持父节点无法选中而子节点能选中则可以删除此节点
   */
  @Builder
  notificationListBackground() {
    Column()
      .width('100%')
      .height(DeviceHelper.isPC() ? undefined : '100%')
      .opacity(0)
      .focusable(this.backgroundFocusable)
      .hitTestBehavior(HitTestMode.Transparent)
      .accessibilityLevel('no-hide-descendants')
  }

  private isInNtfVisibleList = (eventPosY: number, eventPosX: number, itemIndex?: number): boolean => {
    itemIndex = itemIndex === undefined ? this.lastIndex : itemIndex;
    let groupKey = this.getListItemKey(itemIndex);
    if (groupKey === TRANSPARENT_CARD_ID) {
      groupKey = this.getListItemKey(itemIndex - 1);
    }
    let firstGroupKey = this.getListItemKey(this.firstIndex);
    if (!groupKey || !firstGroupKey) {
      log.showInfo('list click, list is empty, then ntf panel dismiss.');
      return false;
    }
    const rectInfo = this.getRectInfoById(groupKey);
    let rectBottom = rectInfo.bottom;
    if ((this.ntfAnimationParas.get(groupKey)?.clearAnimOpacity ?? 0) < 1) {
      // 如果通知卡片处于堆叠态，则取List组件的底部作为底部边界
      rectBottom = this.getRectInfoById(NotificationConstants.NTF_LIST_ROW_ID).bottom;
    }
    const firstRectInfo = this.getRectInfoById(firstGroupKey);
    return eventPosY >= firstRectInfo.top && eventPosY <= rectBottom && eventPosX >= rectInfo.left &&
      eventPosX <= rectInfo.right;
  }

  private getExtraNtfListItemModifier(entry: NotificationEntry): NtfListItemModifier {
    if (this.showExtraNtfsCollapsed()) {
      return this.getListItemModifier(NTF_EXTRA_CONTENT_BRIEF_ID);
    } else if (this.isExtraNtfsCollapseStatusChanging) {
      let ntfListItemModifier: NtfListItemModifier = this.getListItemModifier(entry?.getGroupKey());
      ntfListItemModifier.attribute?.zIndex(this.extraNtfList.length - this.getNtfIndex(entry));
      return ntfListItemModifier;
    } else {
      return this.getListItemModifier(entry?.getGroupKey());
    }
  }

  /**
   * 记忆折叠展开状态,用户点击行为才可以更改折叠展开状态.
   * 当列表为折叠态时,还需要通知列表长度大于1才会展示折叠卡片. 仅有一条通知时仍正常显示单通知卡片
   * @returns
   */
  private showExtraNtfsCollapsed(): boolean {
    if (!this.isExtraNtfsCollapsed) {
      return false;
    }
    if (this.extraNtfList) {
      return this.extraNtfList.length > 1;
    }
    return false;
  }

  @Builder
  buildExtraNtfItem(entry: NotificationEntry) {
    ListItem() {
      if (this.showExtraNtfsCollapsed()) {
        this.buildExtraContentBrief();
      } else {
        this.buildNtfListItem(entry);
      }
    }
    .clip(this.isExtraNtfsCollapseStatusChanging ? this.getNtfIndex(entry) === 0 : false)
    .id(this.showExtraNtfsCollapsed() ? NTF_EXTRA_CONTENT_BRIEF_ID : entry.getGroupTypeKey())
    .attributeModifier(this.getExtraNtfListItemModifier(entry))
    .borderRadius(this.showExtraNtfsCollapsed() ? $r('app.float.ntf_list_content_border_radius') :
      (this.radiusSyncState >= 0 ? this.borderRadiusMap?.get(entry.getGroupTypeKey()) ?? 0 : 0))
    .backgroundColor(this.checkIsBgColorExist(entry) ? this.colorModeVM?.themeBgColor : undefined)
    .backgroundBrightnessInternal(this.checkIsBgColorExist(entry) ? this.colorModeVM?.themeBgBrightnessOption :
      undefined)
    .onSizeChange((this.showExtraNtfsCollapsed()) ? undefined :
      (oldVal: SizeOptions, newVal: SizeOptions) => this.onListItemSizeChange(oldVal, newVal, entry))
    .translate({
      y: this.translateYArr[this.getMainNtfListWithMemory().length + this.getExtraNtfListWithMemory()?.indexOf(entry)]
    })
  }

  private checkIsBgColorExist(entry: NotificationEntry): boolean {
    return this.isExtraNtfsCollapseStatusChanging &&
      entry.getGroupTypeKey() === this.getExtraNtfListWithMemory()[0]?.getGroupTypeKey();
  }

  @Builder
  buildExtraContentBrief() {
    NotificationExtraContentBrief({
      ntfAniParameters: this.ntfAnimationParas.get(NTF_EXTRA_CONTENT_BRIEF_ID),
      isExtraNtfsCollapseStatusChanging: this.isExtraNtfsCollapseStatusChanging,
      colorModeVM: this.colorModeVM,
      ntfExtraGroupBriefScale: this.extraNtfsCollapsedBriefScale,
      extraNtfCollapsedAnimation: this.extraNtfCollapsedAnimation,
      onClickCB: this.contentBriefClickEvent,
      isCreatedExtraBriefWhenCollapsed: this.isCreatedExtraBriefWhenCollapsed,
    })
      .clip(false)
      .id(TAG + '_ExtraContentBrief')
      .scale({ x: this.extraNtfsCollapsedBriefScale, y: this.extraNtfsCollapsedBriefScale })
      .onTouch((event: TouchEvent): void => this.contentBriefTouchEvent(event))
      .geometryTransition(this.isNeedGeometryTransition ? EXTRA_NTF_TRANSITION_ID + this.getFirstExtraNtfKey() :
        undefined, { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
      .transition(TransitionEffect.OPACITY)
  }

  private getFirstExtraNtfKey(): string | undefined {
    if (this.extraNtfList) {
      return this.extraNtfList[0]?.getGroupTypeKey();
    }
    return undefined;
  }

  private contentBriefTouchEvent(event: TouchEvent): void {
    if (!this.ntfAnimationParas.get(NTF_EXTRA_CONTENT_BRIEF_ID)?.isItemEnable()) {
      return;
    }
    if (event.type === TouchType.Move) {
      if (this.extraNtfsCollapsedBriefScale !== 1 &&
        Math.abs(this.touchStartX - event.changedTouches[0].windowX) > 4 ||
        Math.abs(this.touchStartY - event.changedTouches[0].windowY) > 4) {
        animateTo(NotificationConfig.NOTIFICATION_CLICK_ANIM, () => {
          this.extraNtfsCollapsedBriefScale = 1;
          this.extraNtfsCollapsedBriefScale = 1;
        })
      }
      return;
    }
    if (event.type === TouchType.Down) {
      this.touchStartX = event.changedTouches[0].windowX;
      this.touchStartY = event.changedTouches[0].windowY;
      animateTo(NotificationConfig.NOTIFICATION_CLICK_ANIM, () => {
        this.extraNtfsCollapsedBriefScale = 0.95;
        this.extraNtfsCollapsedBriefScale = 0.95;
      })
    }
    if (event.type === TouchType.Up) {
      animateTo(NotificationConfig.NOTIFICATION_CLICK_ANIM, () => {
        this.extraNtfsCollapsedBriefScale = 1;
        this.extraNtfsCollapsedBriefScale = 1;
      })
    }
  }

  private contentBriefClickEvent = (): void => {
    if (this.extraNtfList === undefined || this.extraNtfList.length === 0) {
      log.showWarn('ContentBriefClickEvent on empty extra ntf list');
      return;
    }
    this.isCreatedExtraBriefWhenCollapsed = this.isExtraNtfsCollapsed;
    this.extraBrief = this.extraNtfList[0];
    if (this.showExtraNtfsCollapsed()) {
      this.extraNtfCollapsedAnimation?.updateExtraNtfVisibleCount(this.calExtraNtfVisibleCount());
    }
    AccessibilityUtil.sendAccessibilityByResource($r('app.string.cc_accessibility_str_ntf_swipe_left_text'))
    this.extraNtfsTransitionAnimations = this.extraNtfCollapsedAnimation?.getExtraNtfAnimationArray();
    this.isExtraNtfsCollapseStatusChanging = true;
    animateTo({
      duration: this.extraNtfCollapsedAnimation?.extraNtfCollapsedDuration,
      curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE,
      onFinish: () => {
        this.isExtraNtfsCollapseStatusChanging = false;
      }
    }, () => {

      this.isExtraNtfsCollapsed = !this.isExtraNtfsCollapsed
      log.showInfo(`Content Brief click, status is ${this.isExtraNtfsCollapsed}`);
    });
  };

  @Builder
  buildNtfListItem(entry: NotificationEntry) {
    NotificationListItem({
      ntfGroupEntry: entry,
      changeAppPinTopConfig: this.changeAppPinTopConfig,
      radius: this.radiusSyncState >= 0 ? this.borderRadiusMap?.get(entry.getGroupTypeKey()) ?? 0 : 0,
      ntfAniParameters: this.ntfAnimationParas.get(entry.getGroupTypeKey()),
      colorModeVM: this.colorModeVM,
      ntfAnimVM: this.ntfAnimVM,
      fisrtExtraNtfDelayTime: this.isExtraNtfsCollapseStatusChanging && this.getNtfIndex(entry) == 0 ?
      this.extraNtfCollapsedAnimation?.getFirstExtraNtfDelayTime() : undefined,
      isInExtraNtfList: this.isExtraNtfsCollapseStatusChanging,
      isDropDownAniFin: this.isDropDownAniFin,
      isHalfFold: this.isHalfFold,
      scrollUpIfNeed: this.scrollUpIfNeed,
    })
      .geometryTransition(EXTRA_NTF_TRANSITION_ID + entry?.getGroupTypeKey(),
        { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
      .transition(this.getExtraTransition(entry))
      .constraintSize({
        minHeight: this.extraNtfMinHeight
      })
  }

  build() {
    Row() {
      if (!DeviceHelper.isPC() || this.isRootLoad) {
        Stack({ alignContent: Alignment.TopEnd }) {
          this.notificationListBackground()

          List({ space: this.ntfListVM?.getNtfListStyle()?.ntfItemSpace, scroller: this.listScroller?.getScroller() }) {
            // 下拉面板无数据，在list中显示
            if (this.isShowNtfEmptyTips && this.emptyTipBuilder) {
              ListItem() {
                this.emptyTipBuilder()
              }
              .opacity(this.emptyListTipOpacity)
              .animation({
                duration: 100,
                curve: Curve.Friction
              })
              .width('100%')
              .align(Alignment.Center)
            } else { // 有数据
              ForEach(this.getMainNtfListWithMemory(), (entry: NotificationEntry) => {
                ListItem() {
                  NotificationListItem({
                    ntfGroupEntry: entry,
                    changeAppPinTopConfig: this.changeAppPinTopConfig,
                    radius: CardScaleUtil.getRadius(false,
                      this.radiusSyncState >= 0 ? this.borderRadiusMap?.get(entry.getGroupTypeKey()) ?? 0 : 0),
                    ntfAniParameters: this.ntfAnimationParas.get(entry.getGroupTypeKey()),
                    updateAnimationParas: this.updateAnimationParas,
                    colorModeVM: this.colorModeVM,
                    ntfAnimVM: this.ntfAnimVM,
                    isNeedPanelInScreenLock: this.isNeedPanelInScreenLock,
                    isShowBannerFromScreenLock: this.isShowBannerFromScreenLock,
                    isLockScreen: this.isLockScreen,
                    isSecureAndLocked: this.isSecureAndLocked,
                    isHalfFold: this.isHalfFold,
                    isDropDownAniFin: this.isDropDownAniFin,
                    scrollUpIfNeed: this.scrollUpIfNeed,
                  })
                }
                .translate({
                  y: this.translateYArr[this.getMainNtfListWithMemory().indexOf(entry)]
                })
                .transition(this.isDropDownAniFin ? this.getMainTransition(entry) : undefined)
                .clip(false)
                .onSizeChange(
                  (oldValue: SizeOptions, newValue: SizeOptions) => this.onListItemSizeChange(oldValue, newValue, entry))
                .id(entry.getGroupTypeKey())
                .attributeModifier(this.getListItemModifier(entry?.getGroupTypeKey()))
              }, (entry: NotificationEntry, index: number): string => { //请勿删除index，否则会导致组件销毁重建
                return entry.uid;
              })
              if (this.extraNtfList.length > 0) {
                ListItem() {
                  NotificationExtraHeader({
                    ntfAniParameters: this.getHeaderAnimationParas(),
                    isExtraNtfsCollapseStatusChanging: this.isExtraNtfsCollapseStatusChanging,
                    transparentCardHeight: this.transparentCardHeight,
                    colorModeVM: this.colorModeVM,
                    extraNtfCollapsedAnimation: this.extraNtfCollapsedAnimation,
                    extraNtfAnimationArray: this.extraNtfsTransitionAnimations,
                    hasMainNtf: this.getMainNtfListWithMemory().length > 0,
                    calExtraNtfVisibleCount: this.calExtraNtfVisibleCount,
                    extraBrief: this.extraBrief,
                    isCreatedExtraBriefWhenCollapsed: this.isCreatedExtraBriefWhenCollapsed,
                    hideMoreNtfActionButtons: this.hideMoreNtfActionButtons,
                  })
                }
                .margin({
                  bottom: 0 // TV的更多通知与下方的通知间距特殊处理
                })
                .id(NotificationConstants.NTF_CENTER_EXTRA_HEADER_COMP_ID)
                .attributeModifier(this.getListItemModifier(this.showExtraNtfsCollapsed() ? NTF_EXTRA_CONTENT_BRIEF_ID
                  : this.extraNtfList[0]?.getGroupTypeKey()))
                .translate({
                  y: this.translateYArr[this.getMainNtfListWithMemory().length]
                })
                ForEach(this.getExtraNtfListWithMemory(), (entry: NotificationEntry, index: number) => {
                  this.buildExtraNtfItem(entry);
                }, (entry: NotificationEntry, index: number): string => { //请勿删除index，否则会导致组件销毁重建
                  return entry.uid;
                })
              }
              if (this.isShowBottomTransCard) {
                // 新增一个透明占位卡片，使滑动到最底部与一键删除垃圾桶不重叠
                ListItem() {}
                .id(TRANSPARENT_CARD_ID)
                .accessibilityLevel('no')
                .height(DeviceHelper.isPC() ? 8 : this.transparentCardHeight)
                .opacity(0)
                .width('100%')
              }
            }
          }
          .contentStartOffset(this.contentStartOffset)
          .id(NotificationConstants.NTF_LIST_ROW_ID)
          .opacity(this.hasInitOpacity ? 1 : 0)
          .padding(DeviceHelper.isPC() ?
            {
              start: LengthMetrics.resource($r('app.float.ntf_list_item_padding_start_end')),
              end: LengthMetrics.resource($r('app.float.ntf_list_item_padding_start_end')),
              top: LengthMetrics.resource($r('app.float.ntf_item_shadow_border_padding_top'))
            } : undefined)
          // 使用特定path切割，保留圆角的同时两侧留出50vp空间
          .clip(this.getListClip())
          .borderRadius(this.getListBorderRadius())
          .cachedCount(this.isExtraNtfsCollapseStatusChanging ? 0 : this.listContentConfig.cachedCount,
            this.isGroupExpanding || this.isUpdatingData ? true : false)
          .edgeEffect(this.edgeEffect)
          .enableScrollInteraction(!(this.isDisplayLand && this.getIsShowNtfEmptyTips()))
          .width(CardScaleUtil.getWidth(false, '100%'))
          .height(CardScaleUtil.getHeight(false,
            this.ntfAnimVM?.getListHeight(this.ntfAreaRect.height)))
          .scale(CardScaleUtil.getScale(false, CardScaleType.SCALE_CENTER))
          .scrollBar(DeviceHelper.isPC() ? BarState.Auto : BarState.Off)
          .hitTestBehavior(this.isAccessibilityMode ? HitTestMode.Default : HitTestMode.Transparent)
          // 监听到达底部
          .onReachEnd(() => {
            if (!this.isNtfShow) {
              return;
            }

            // 滑动到底部时，如果最后一个卡片没有完全显示，则等待完全显示
            this.itemScrollOffset = 0;
            this.isAlreadyOverEnd = false;
            if (!this.checkIsAnimating(this.lastIndex)) {
              this.listScroller?.setReachEnd(true);
            }
          })
          .onReachStart(() => {
            this.listScroller?.setReachEnd(false);
          })
          .onScrollIndex((firstIndex: number, lastIndex: number) => {
            this.updateTopAndBottomAnimParams(firstIndex, lastIndex);
            this.firstIndex = firstIndex;
            this.updateLastIndex(lastIndex);
            log.showInfo(`Index change, first index is ${firstIndex}, last index is ${lastIndex},${this.lastIndex}`);
            this.extraNtfCollapsedAnimation?.updateFirstAndLastIndex(this.firstIndex, this.lastIndex);
            this.ntfAnimVM?.setClearAllDelay(firstIndex, lastIndex);
            // 非展开通知组场景，更新动效参数防止显示异常
            if (!this.isGroupExpanding) {
              this.updateNtfAnimationParas();
            }
            // 没满一屏通知重置listHeadTranY
            if (this.listHeadTranY !== 0 && this.firstIndex === 0 && this.lastIndex === this.getMaxIndex()) {
              this.listHeadTranY = 0;
            }
          })
          .constraintSize({
            maxHeight: this.maxHeight,
          })
          .onAreaChange((oldValue: Area, newValue: Area) => {
            if (this.ntfAnimVM?.checkClearingAll()) {
              return;
            }
            if (this.orientationChanged && this.dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL) {
              // 横竖屏切换后根据新的index值计算仿射参数
              this.listRectInfo = this.getNtfListRowRectInfo();
              NtfScrollAnimation.listRect = this.getNtfListRowRectInfo();
              this.updateNtfAnimationParas();
              this.orientationChanged = false;
            }
            this.changeNtfAreaRect(newValue);
          })
          // 监听触摸事件
          .onTouch((event) => {
            // down点记录当前偏移量
            if (event?.type == TouchType.Down) {
              log.showInfo(`onTouch.`);
              this.deleteNtfInfo?.reset();
              this.itemScrollOffset = 0;
              this.startScrollOffset = 0;
              this.isAlreadyEverEnd = this.isAlreadyOverEnd;
              this.isAlreadyOverEnd = false;
              this.reachEndOffset = -Number(this.listScroller?.getCurrentOffset());
              this.isAlreadyReachEnd = this.listScroller?.isReachEnd as boolean;
              if (Math.ceil(event?.touches[0].y + BOTTOM_TRIGGER_RANGE) >= this.phoneNtfListHeight) {
                this.isDragFromBottom = true;
                this.isAlreadyReachEnd = true;
              }
              this.updateDataInterceptor?.setIsEnabled(false);
            }
            if (event?.type == TouchType.Up) {
              this.isDragFromBottom = false;
              this.updateDataInterceptor?.setIsEnabled(true);
            }
          })
          // 下拉面板监听开始滑动
          .onScrollFrameBegin((offset) => {
            this.startScrollOffset = offset;
            EvtBus.post(NtfListScrollEvent, new NtfListScrollEvent());
            // 当前在底部，向下滑动，则置为非底部
            if (this.listScroller?.isReachEnd && offset < 0) {
              this.listScroller?.setReachEnd(false);
            }
            if (!this.listScroller?.isReachEnd && this.isAlreadyReachEnd && this.isDragFromBottom) {
              this.isAlreadyReachEnd = false;
              log.showInfo('onScrollFrameBegin isAlreadyReachEnd false');
            }

            return { offsetRemain: offset }
          })
          // 下拉面板滑动监听
          .onScroll(this.ntfListVM?.isDropdown ? (scrollOffset: number, scrollState: ScrollState) => {
            // 滑动动作带来的仿射变换参数变化
            this.scrollState = scrollState;
            if (this.isNtfShow) {
              this.updateListHeadTranY(scrollOffset, scrollState);
              // 上滑过程中，若出现回弹，则认为已触底
              if (!this.isAlreadyOverEnd && this.startScrollOffset > 0 && this.itemScrollOffset > 0 && scrollOffset < 0) {
                this.isAlreadyOverEnd = true;
              }
              this.itemScrollOffset = scrollOffset;
              if (scrollState === 0) {
                this.updateScrollStopAnim(scrollOffset);
              } else {
                // 标识是否上滑
                this.updateNtfAnimationParas(scrollOffset > 0);
              }
            }
            // 平移值正数与scroll负数对应
            let tranY = -Number(this.listScroller?.getCurrentOffset());
            // 获取用户滑动最大距离
            this.maxDropDownDis = Math.max(this.maxDropDownDis, -tranY);

            // 滑动过程中未触底，则记录当前偏移量
            if (!this.listScroller?.isReachEnd && this.isDragFromBottom) {
              this.reachEndOffset = tranY;
              this.isAlreadyReachEnd = false;
              this.startScrollOffset = 0;
              this.isAlreadyOverEnd = false;
            } else { // 如果已经触底，则判断是否达到阈值
              if (tranY - this.reachEndOffset < this.listContentConfig.dropDownPanelDistance) {
                // 收起面板
                if (scrollState === ScrollState.Scroll && (this.isAlreadyReachEnd || this.isAlreadyEverEnd)) {
                  DropDownPanelManager.animDelayToDismiss(0);
                  this.isAlreadyReachEnd = false;
                }
              }
            }
          } : undefined)
          .onScrollStart(() => {
            performanceMonitor.begin('SCROLL_NC_LIST_ANI', performanceMonitor.ActionType.FIRST_MOVE);
            this.isScrolling = true;
            this.updateDataInterceptor?.requestInterrupt();
            AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
          })
          .onScrollStop(() => {
            this.isScrolling = false;
            this.updateDataInterceptor?.releaseInterrupt();
            performanceMonitor.end('SCROLL_NC_LIST_ANI');
            AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
            // 打点
            const params: NotificationPanelSlideParams = {
              TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
              SLIDE_DISTANCE: SlideType.SCROLL_STOP
            }
            NotificationSysEventReporter.notificationPanelSlide(params);
          })
        }
        // list的外层容器要预留出空间，PC为阴影不切割
        .clip(DeviceHelper.isPC())
        .accessibilityLevel('no')

        // 通知卡片右键点击弹出通知设置
        if (this.isShowRightMenu()) {
          NotificationSettings()
        }
        // 通知卡片右上角关闭按钮
        if (this.closeVM) {
          NotificationClose({
            isFromNtf: true
          })
        }
      }
    }
    .onAppear(() => {
      this.isRootLoad = true;
    })
    .accessibilityLevel('no')
    .alignItems(VerticalAlign.Top)
    // 跟随位移
    .translate({
      y: this.listFollowTranY * this.transYCoefficient
    })
    .animation(NtfDropdownController.isVisible() ? this.ntfFollowAnim! : undefined)
    .padding(this.listPadding)
    .id(NotificationConstants.NTF_LIST_CONTENT_ROW_ID)
    .width('100%')
    .height('100%')
    .onAreaChange(this.closeVM ? (oldArea, newArea) => {
      this.closeVM!.setContainerPosition(newArea.globalPosition);
    } : null)
    .overlay(!(this.isNeedPanelInScreenLock && this.isLockScreen) ? undefined : this.buildSysFloatTipDialog(),
      { align: Alignment.Bottom })
  }

  @Builder
  buildSysFloatTipDialog() {
    SysFloatTipDialog({
      componentId: ScreenLockNotificationConst.NTF_OUT_DROPDOWN_PANEL_KEY_GUARD_TIP,
      tipMarginBottom: 24
    })
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.None)
  }

  private updateListHeadTranY(scrollOffset: number, scrollState: ScrollState): void {
    // 列表滑动到顶时，计算到顶后向下平移的距离，用做“时间日期”组件跟随下移的距离参考值，Idel状态时获取rectInfo不准。
    if (this.firstIndex !== 0 || scrollState === ScrollState.Idle) {
      this.doUpdateFirstCardTransYAnim(this.getListHeadTranY());
      return;
    }
    if (this.ntfFollowTranY > 0) {
      this.listHeadTranY = 0;
    } else {
      this.setUpdateListHeadTranY(scrollOffset, scrollState);
    }
    if (this.listHeadTranY !== 0) {
      this.ntfFollowAnim = null;
    }
  }

  private setUpdateListHeadTranY(scrollOffset: number, scrollState: ScrollState): void {
    let newListHeadTranY = this.getListHeadTranY();
    let transYDiff = Math.abs(newListHeadTranY - this.listHeadTranY);
    let directlySetValue =
      scrollState === ScrollState.Fling || Math.abs(scrollOffset) >= 0.5 || transYDiff <= 0.4;
    if (directlySetValue) {
      this.listHeadTranY = newListHeadTranY;
      this.doUpdateFirstCardTransYAnim(newListHeadTranY);
      return;
    }
    animateTo({ curve: Curve.Smooth, duration: transYDiff * 40 }, () => {
      this.listHeadTranY = newListHeadTranY;
    });
  }

  private getListHeadTranY(): number {
    const topItemId = (this.mainNtfList.length === 0) ? NotificationConstants.NTF_CENTER_EXTRA_HEADER_COMP_ID :
    this.mainNtfList[0].getGroupKey();
    const rect = this.getRectInfoById(topItemId);
    return Math.max(0, rect.top - (this.listRectInfo?.top ?? 0));
  }

  private doUpdateFirstCardTransYAnim(newListHeadTranY: number): void {
    if (this.isNtfListChanging || this.isExtraNtfsCollapseStatusChanging) {
      animateTo({ duration: this.ntfAnimVM?.getNtfListDataChangeDuration(), curve: Curve.Friction, }, () => {
        this.updateFirstCardTransY?.(newListHeadTranY);
      })
    } else {
      this.updateFirstCardTransY?.(newListHeadTranY);
    }
  }

  onNtfStyleChange(ntfStyle: NotificationListStyle): void {
    log.showInfo(`onNtfStyleChange refresh padding`);
    this.listPadding = this.getPadding();
  }

  private getPadding(): Padding | Length {
    if (this.ntfListVM?.isPc()) {
      return 0;
    }
    if (this.ntfListVM?.isPadLayout()) {
      return {
        bottom: this.isDisplayLand ? $r('app.float.ntf_list_land_item_padding_bottom')
          : $r('app.float.ntf_list_item_padding_bottom')
      }
    }
    // 是否设置通知左右边距，小折叠类按直板机处理，超大屏单屏按直板机处理
    let noLeftRightPadding = this.isDisplayLand ||
      (this.isFoldFullDisplay && !this.ntfListVM?.isSmallFold() && !LayoutUtils.isMatchXTFoldMode(XTLayoutType.F));
    return {
      left: noLeftRightPadding ? 0 : $r('app.float.ntf_list_item_padding_start_end'),
      right: noLeftRightPadding ? 0 : $r('app.float.ntf_list_item_padding_start_end'),
      bottom: this.isDisplayLand ? $r('app.float.ntf_list_land_item_padding_bottom')
        : $r('app.float.ntf_list_item_padding_bottom'),
      top: this.isDisplayLand && !LayoutUtils.isMatchXTFoldMode(XTLayoutType.M) ?
      $r('app.float.ntf_land_title_padding_top') : 0
    };
  }
  private updateScrollStopAnim(scrollOffset: number) {
    this.changeIndex = 0;
    if (Math.abs(scrollOffset) > 5 && !this.deleteNtfInfo?.realHeight) {
      //避免scrollOffset值较大（更多通知展开折叠），第一张卡片位置跳变
      animateTo({
        duration: 100,
        curve: Curve.Linear,
      }, () => {
        this.updateNtfAnimationParas(scrollOffset > 0);
      })
    } else if (scrollOffset !== 0) {
      // 标识是否上滑
      this.updateNtfAnimationParas(scrollOffset > 0);
    }
  }
  private isLastNtfAnimationUpdatedFinished(): boolean {
    let maxIndex = this.getMaxIndex();
    let groupKey: string | undefined = this.getListItemKey(maxIndex);
    if (groupKey == undefined) {
      return false;
    }
    // 往上滑的时候，如果最后一个通知的动效参数已经修改，则不需要再修改所有通知的动效参数
    return this.lastIndex == maxIndex && this.ntfAnimationParas.get(groupKey)?.clearAnimOpacity == 1;
  }

  private getMaxIndex(): number {
    let num = 0
    const mainNtfListLength = this.getMainNtfListWithMemory()?.length ?? 0;
    const extraNtfListLength = this.getExtraNtfListWithMemory()?.length ?? 0;
    if (this.showExtraNtfsCollapsed()) {
      num = mainNtfListLength + 1;
    } else {
      num = this.extraNtfList?.length > 0 ? mainNtfListLength + extraNtfListLength : Math.max(mainNtfListLength - 1, 0);
    }
    return this.isShowBottomTransCard ? num + 1 : num
  }

  private getListClip(): boolean | CircleAttribute | EllipseAttribute | PathAttribute | RectAttribute {
    if (DeviceHelper.isPC()) {
      return false;
    }
    return this.getClipPath();
  }

  private getListBorderRadius(): Length | BorderRadiuses | LocalizedBorderRadiuses {
    if (DeviceHelper.isPC()) {
      return { bottomEnd: LengthMetrics.vp(20) };
    }
    return NotificationConfig.BORDER_RADIUS;
  }
  private getMainNtfList(): Array<NotificationEntry> {
    let mainNtfList = this.ntfList?.filter(entry =>!entry.isExtraContentType());
    // 获取第一条主分区的通知消息
    return mainNtfList;
  }

  private getExtraNtfList(): Array<NotificationEntry> {
    let extraNtfList = this.ntfList?.filter(entry => entry.isExtraContentType());
    log.showInfo('update extra ntf list, new length : ' + extraNtfList.length);
    return extraNtfList;
  }

  private startNtfItemAnimByRow(isShow: boolean, isWithAnim: boolean, index: number): void {
    let delayStep = isShow ? APPEAR_DELAY : DISAPPEAR_DELAY;
    let count = this.lastIndex - this.firstIndex + 1;
    let delta = index - this.firstIndex;
    let groupTypeKey = '';
    let entry = this.ntfListVM?.getNtfListAdapter().getData(index as number);

    //应急模式下只展示白名单已有应用的消息
    let isInEmergencyOrThermalSafeMode = getIsInEmergencyOrThermalSafeMode(this.deviceModeState);
    if (isInEmergencyOrThermalSafeMode && this.ntfList !== undefined) {
      entry = this.ntfList[index];
      log.showInfo(`start show emergency notification, index ${index}`);
    }

    if (entry) {
      groupTypeKey = entry.getGroupTypeKey();
    }

    if (this.showExtraNtfsCollapsed() && this.getListItemKey(1 + (index as number)) === NTF_EXTRA_CONTENT_BRIEF_ID) {
      groupTypeKey = NTF_EXTRA_CONTENT_BRIEF_ID;
    }
    if (!groupTypeKey || !entry) {
      return;
    }
    const ntfAnimationParam = this.ntfAnimationParas.get(groupTypeKey);
    if (ntfAnimationParam) {
      ntfAnimationParam.ntfItemTranslateY = 0;
      ntfAnimationParam.ntfItemTranslateX = 0;
      ntfAnimationParam.ntfItemRotateAngels = 0;
    }

    // Change directly when without animation or switch from center control
    let isChangeDirectly: boolean = (isShow && !this.isFromDeskTop()) ||
      (!isWithAnim && !CommonUtils.isInvalid(ntfAnimationParam));
    if (isChangeDirectly) {
      if (ntfAnimationParam) {
        ntfAnimationParam.clearAnimOpacity = isShow ? 1 : 0;
        ntfAnimationParam.clearAnimScale = isShow ? 1 : ITEM_SCALE;
        ntfAnimationParam.ntfItemRotateAngels = 0;
        ntfAnimationParam.ntfItemTranslateY = 0;
        ntfAnimationParam.ntfItemTranslateX = 0;
      }
      if (isShow && (this.getListItemKey(this.lastIndex) === entry?.getGroupTypeKey() ||
        this.getListItemKey(this.lastIndex) === NotificationConstants.NTF_CENTER_EXTRA_HEADER_COMP_ID ||
        this.getListItemKey(this.lastIndex) === NTF_EXTRA_CONTENT_BRIEF_ID)) {
        this.updateBottomNtfAnimationParas();
        this.initOtherNtfPara(this.lastIndex + 1)
      }
      return;
    }

    let delay = delayStep * (isShow ? delta : (count - 1 - delta));
    this.performItemAnimByRow(groupTypeKey, delay, isShow, index);
  }

  private isFromDeskTop(): boolean {
    return this.dropDownEvent.source === TargetPanel.NONE &&
      this.dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL;
  }

  private performItemAnimByRow(groupTypeKey: string, delayTime: number,
                               isShow: boolean, index: number): void {
    log.showInfo('performItemAnim start animation params. index = ' + index + ', delayTime = ' + delayTime +
      ', groupTypeKey = ' + groupTypeKey);
    let ntfAnimationParam = this.ntfAnimationParas.get(groupTypeKey);
    if (!ntfAnimationParam) {
      const newNtfAnimationParam = new NotificationAnimationParas(0, 0, 0, 1, 0);
      this.ntfAnimationParas.set(groupTypeKey, newNtfAnimationParam);
      ntfAnimationParam = newNtfAnimationParam;
    }
    ntfAnimationParam.clearAnimScale = !isShow ? 1 : ITEM_SCALE;
    ntfAnimationParam.clearAnimOpacity = !isShow ? 1 : 0;
    // Make last item fold if necessary
    //小外屏列表为平铺，最后一张卡片无需特殊处理,保证最后一张卡片能够在下拉初始场景展示
    if ((groupTypeKey === this.getListItemKey(this.lastIndex) || index === this.lastIndex) && isShow &&
      this.listContentConfig.isNtfListFold) {
      this.handleTheLastItem(groupTypeKey, delayTime, index);
      return;
    }

    this.performItemShapeAnim(SHAPE_ANIMATION_DURATION, delayTime,
      () => {
        this.animationCount++;
        if (ntfAnimationParam) {
          ntfAnimationParam.clearAnimScale = isShow ? 1 : ITEM_SCALE;
        }
      },
      () => {
        this.handleAnimationFinish();
        if (index === this.lastIndex) {
          this.dropDownEvent.pullFraction = 1;
        }
      }
    );

    this.startItemOpacityAnim(groupTypeKey, delayTime, isShow);
  }

  private startItemOpacityAnim(groupTypeKey: string, delayTime: number, isShow: boolean) {
    const ntfAnimationParam = this.ntfAnimationParas.get(groupTypeKey);
    let tempClearAnimOpacity = isShow ? 1 : 0;
    log.showInfo('startItemOpacityAnim, hashCode: ' + groupTypeKey + ' opacity: ' +
      ntfAnimationParam?.clearAnimOpacity + ', translateY: ' +
      ntfAnimationParam?.ntfItemTranslateY + ', scale: ' +
      ntfAnimationParam?.clearAnimScale);
    if (ntfAnimationParam?.clearAnimOpacity != tempClearAnimOpacity) {
      let tempOpacityAnimCount = this.getOpacityAnimCount(groupTypeKey);
      this.performItemOpacityAnim(isShow ? OPACITY_APPEAR_ANIMATION_DURATION : OPACITY_DISAPPEAR_ANIMATION_DURATION,
        delayTime, () => {
          if (ntfAnimationParam) {
            ntfAnimationParam.clearAnimOpacity = isShow ? 1 : 0;
          }
        }, () => {
          if (this.clearAllFlag || this.getListItemKey(this.lastIndex) === groupTypeKey) {
            return;
          }
          if (tempOpacityAnimCount === this.opacityAnimCountRecords.get(groupTypeKey) &&
            ntfAnimationParam) {
            ntfAnimationParam.clearAnimOpacity = isShow ? 1 : 0;
            ntfAnimationParam.clearAnimScale = isShow ? 1 : ITEM_SCALE;
            ntfAnimationParam.ntfItemRotateAngels = 0;
            ntfAnimationParam.ntfItemTranslateY = 0;
            ntfAnimationParam.ntfItemTranslateX = 0;
          }
        });
    }
  }

  private getOpacityAnimCount(groupTypeKey: string): number {
    let opacityAnimCount = this.opacityAnimCountRecords.get(groupTypeKey);
    if (!opacityAnimCount) {
      opacityAnimCount = 0;
    } else if (opacityAnimCount >= Number.MAX_SAFE_INTEGER) {
      opacityAnimCount = 0;
    }
    this.opacityAnimCountRecords.set(groupTypeKey, ++opacityAnimCount);
    return opacityAnimCount;
  }

  private handleTheLastItem(groupTypeKey: string, delayTime: number, index: number) {
    let tempOpacityAnimCount = this.getOpacityAnimCount(groupTypeKey);
    let lastItemOpacity: number | undefined = 1;
    const ntfAnimationParam = this.ntfAnimationParas.get(groupTypeKey);
    this.performItemShapeAnim(TRANSLATE_Y_DISAPPEAR_ANIMATION_DURATION, delayTime,
      () => {
        // 更新动效参数后再更新Z轴索引
        this.animationCount++;
        this.updateBottomNtfAnimationParas();
        lastItemOpacity = ntfAnimationParam?.clearAnimOpacity;
        this.updateNtfZIndexParam();
      },
      () => {
        this.handleAnimationFinish();
        if (index === this.lastIndex) {
          this.isDropDownAniFin = true;
          this.dropDownEvent.pullFraction = 1;
          // 执行动效过程中，数据更新导致index与groupTypeKey关系变化，重新取值
          const nowGroupTypeKey = this.getListItemKey(index);
          // 快速下拉并反悔场景下，防止最后一张卡片设置参数后之后被反悔收起时改变参数，需要对比参数
          if (nowGroupTypeKey && tempOpacityAnimCount === this.opacityAnimCountRecords.get(nowGroupTypeKey) &&
            ntfAnimationParam?.clearAnimOpacity !== lastItemOpacity) {
            log.showInfo(`show the ntfCard and reset the wrong params`);
            if (ntfAnimationParam && lastItemOpacity) {
              this.updateBottomNtfAnimationParas();
            }
          }
        }
      }
    );
  }

  private performItemShapeAnim(duration: number, delay: number, animCallback: () => void, onFinish?: () => void): void {
    animateTo({
      duration: duration, // 动画时长
      curve: SHAPE_ANIMATION_CURVE, // 动画曲线
      delay: delay, // 动画延迟
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
      onFinish: onFinish
    }, animCallback);
  }

  private performItemOpacityAnim(
    duration: number, delay: number, animCallback: () => void, onFinish?: () => void): void {
    animateTo({
      duration: duration, // 动画时长
      curve: OPACITY_ANIMATION_CURVE, // 动画曲线
      delay: delay, // 动画延迟
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
      onFinish: onFinish
    }, animCallback);
  }

  private calculateNtfListHeight(): void {
    let phoneNtfCenterTitleHeight = ResUtils.getNumberFromLength(this.ntfListVM?.isLand()
      ? $r('app.float.ntf_center_header_phone_land_height')
      : $r('app.float.ntf_center_header_phone_height'));
    let statusBarHeight = ResUtils.getNumberFromLength($r('app.float.status_bar_setting_status_bar_height'));
    this.phoneNtfListHeight =
      ArkUIAdapter.px2vp(this.ntfListVM?.getScreenHeight() as number) - phoneNtfCenterTitleHeight - statusBarHeight;
  }

  private handleAnimationFinish(): void {
    this.animationCount--;
    this.onAnimationFinish();
  }

  private onAnimationFinish(): void {
    this.isAlreadyOverEnd = false;
    this.isAlreadyEverEnd = false;
    if (this.animationCount != 0) {
      return;
    }
    TraceUtil.endTrace(DomainName.NC, Trace.CORE_METHOD_DELETE_NOTIFICATION);
    if (!this.isPanelAnimationDone || this.dropDownEvent.target !== TargetPanel.NOTIFICATION_PANEL) {
      if (this.dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL) {
        log.showInfo('ExitNC end');
        TraceUtil.endTrace(DomainName.NC, Trace.CORE_METHOD_NOTIFICATION_PANEL_HIDE);
      }
      // 下拉通知中心初始化记录的滑动距离
      if (this.dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL && !DropDownPanelManager.isPanelDismissing()) {
        this.maxDropDownDis = 0;
        const liveNum: number = this.ntfList.filter((ntf) => {
          return ntf.isLiveType();
        }).length;
        log.showInfo(`dropDown notification panel,` +
          `notification list length = ${this.ntfList.length}, live num = ${liveNum}`);
      }
      // 通知中心收起时滑动距离打点
      if (this.dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL && DropDownPanelManager.isPanelDismissing()) {
        log.showInfo('ntf panel dismiss')
        let dropDownCount = Math.floor(this.maxDropDownDis / this.phoneNtfListHeight);
        let params: NotificationPanelSlideParams = {
          TIME_STAMP: `${sDropDownPanelManager.getLastDropdownTime()}`,
          SLIDE_DISTANCE: dropDownCount < 3 ? dropDownCount : 3
        }
        NotificationSysEventReporter.notificationPanelSlide(params);
        this.maxDropDownDis = 0;
      }
      return;
    }
    // 如果有资源的释放需要重新加载
    this.trimMemory = false;
    log.showInfo('ClearNtAni/IntoNC All notification animation finish, mark renderGroup false.');
    this.isDropDownAniFin = true;
    TraceUtil.endTrace(DomainName.NC, Trace.CORE_METHOD_NOTIFICATION_PANEL_SHOW);
    Trace.end(Trace.CORE_METHOD_START_DROP_DOWN_PANEL);
    performanceMonitor.end('INTO_NC_ANI');
    performanceMonitor.end('EXIT_NC_ANI');
  }

  private getHeaderAnimationParas(): NotificationAnimationParas | undefined {
    if (this.showExtraNtfsCollapsed()) {
      const ret = this.ntfAnimationParas.get(NTF_EXTRA_CONTENT_BRIEF_ID);
      log.showInfo('extraNtfs is collapsed, extra header opacity:%{public}d, zIndex:%{public}d', ret?.clearAnimOpacity, ret?.ntfItemZIndex);
      return ret;
    }
    if (this.extraNtfList.length === 0) {
      log.showInfo(`extraNtfs is empty, extra header param will be undefined`);
      return undefined;
    }
    let entry = this.extraNtfList[0];
    if (!entry) {
      log.showInfo(`extraNtfs[0] is invalid, extra header param will be undefined`);
      return undefined;
    }
    const groupTypeKey = entry.getGroupTypeKey();
    const ret = this.ntfAnimationParas.get(groupTypeKey);
    log.showInfo('extraNtfs header param follow:%{public}s, opacity:%{public}d, zIndex:%{public}d', groupTypeKey, ret?.clearAnimOpacity, ret?.ntfItemZIndex);
    return ret;
  }

  private getNtfIndex(entry: NotificationEntry): number {
    if (this.extraNtfList) {
      for (let index = 0; index < this.extraNtfList.length; index++) {
        if (entry.getGroupTypeKey() == this.extraNtfList[index].getGroupTypeKey()) {
          return index;
        }
      }
    }
    return 0;
  }

  private isShowRightMenu(): boolean {
    return this.ntfListVM?.isPc() ?? false;
  }

  private getRatio(positionYDiff: number, realHeight: number, maxHeight: number, groupKey: string): number {
    const ntfAnimationParam = this.ntfAnimationParas.get(groupKey);
    if (realHeight === 0 && ntfAnimationParam && ntfAnimationParam?.clearAnimScale < 1) {
      return 1;
    }
    return Math.min(Math.abs(positionYDiff) / Math.min(realHeight, maxHeight), 1);
  }

  private getOpacityRatio(ratio: number): number {
    let opacityRatio = ratio;
    if (1 - opacityRatio > OPACITY_THRESHOLD) {
      opacityRatio = Math.min(ratio * OPACITY_GROWTH_MULTIPLIER, 1 - OPACITY_THRESHOLD);
    }
    return opacityRatio;
  }

  private checkIsAnimating(ntfIndex: number): boolean {
    let isAnimating = false;
    let key = this.getListItemKey(ntfIndex);
    if (key !== undefined) {
      const ntfAnimationParam = this.ntfAnimationParas.get(key);
      if (ntfAnimationParam) {
        isAnimating = ntfAnimationParam.clearAnimOpacity < 1;
      }
    }
    return isAnimating;
  }

  private updateLastIndex(lastIndex: number): void {
    this.tempLastIndex = lastIndex;
    if (!this.isGroupExpanding || this.tempLastIndex > this.lastIndex) {
      // 组通知展开过程中不更新lastIndex的值
      this.lastIndex = lastIndex;
    }
  }

  private logWrongIndexInfo(key: string, rectInfo: RectInfo): void {
    const ntfAnimationParam = this.ntfAnimationParas.get(key);
    if (!ntfAnimationParam) {
      return;
    }
    if (ntfAnimationParam?.clearAnimOpacity === 1 && ntfAnimationParam?.ntfItemTranslateY !== 0) {
      // 如果透明度为1，但是位移不为0，说明错位
      log.showInfo('Wrong item, hashCode is ' + key + ', ntfItemTranslateY is ' +
        ntfAnimationParam?.ntfItemTranslateY + ', listRectInfo is (' + this.listRectInfo!.top + ', ' +
      this.listRectInfo!.bottom + '), rectInfo is (' + rectInfo?.top + ', ' + rectInfo?.bottom + ')');
      ntfAnimationParam.ntfItemTranslateY = 0;
    }
  }

  private setEmergencyWhiteList(appInfoList: EmergencyThermalAppType[] | undefined): void {
    if (!appInfoList) {
      return;
    }
    const whiteList = appInfoList.map((item) => {
      return item?.appItem?.bundleName || ''
    });
    this.emergencyWhiteList = [...whiteList];
    EmergencyThermalSafeManager.instance.setBundleWhiteList(this.emergencyWhiteList);
    this.ntfListVM?.postEmergencyNtfStatusIcon();
  }

  private onNtfAnimateEvent = (event: NtfAnimateEvent): void => {
    if (event.eventType === NtfAnimateEvent.EXIT_NC) {
      this.isDropDownAniFin = false;
    }
  };

  private onNtfPinnedEvent = (event: NtfPinnedEvent): void => {
    if (!this.ntfAnimVM) {
      return;
    }
    this.mainNtfAnimation = this.ntfAnimVM.extraNtfListItemTransition;
    for (let i = 0; i < this.getExtraNtfListWithMemory()?.length; i++) {
      if (this.getExtraNtfListWithMemory()[i]?.creatorUid === event.creatorUid) {
        this.extraNtfsTransitionAnimations[i] = this.ntfAnimVM.extraNtfListItemTransition;
      }
    }
  };

  private scrollUpIfNeed = (groupTypeKey?: string): void => {
    if (!groupTypeKey) {
      return;
    }
    const itemRect = this.getRectInfoById(groupTypeKey);
    if (!this.listRectInfo || !itemRect) {
      return;
    }
    const bottomDistance = this.listRectInfo.bottom - itemRect.top - NotificationConstants.NTF_MAX_HEIGHT_THRESHOLD;
    log.showInfo(`scrollUpIfNeed, bottomDistance: ${bottomDistance}`);
    // 可展开的卡片距离列表底部在阈值范围内，展开时列表同时向上滚动;PC产品以及PC模式上不需要该设计
    if (bottomDistance < SCROLL_UP_LAST_CARD_THRESHOLD && !DeviceHelper.isPC()) {
      this.listScroller?.getScroller().scrollBy(0, SCROLL_UP_HEIGHT);
    }
  }

  private onGroupItemExpandingEvent = (event: GroupItemExpandingEvent): void => {
    log.showInfo(`Group item expanding, expand status is ${event.isGroupExpanding}`);
    this.isGroupExpanding = event.isGroupExpanding;
    if (this.groupExpandingTimerId) {
      clearTimeout(this.groupExpandingTimerId);
      this.groupExpandingTimerId = undefined;
    }
    if (event.isGroupExpanding) {
      this.transparentCardHeight = NotificationConstants.TRANSPARENT_CARD_HEIGHT;
      this.groupExpandingTimerId = setTimeout(() => {
        for (let i = this.lastIndex - 1; i > this.tempLastIndex; i--) {
          this.updateTopOrBottomNtfAnimationParas(false, i);
          this.resetNtfItemAnimationParas(i);
        }
        this.lastIndex = this.tempLastIndex;
        this.extraNtfCollapsedAnimation?.updateFirstAndLastIndex(this.firstIndex, this.lastIndex);
        this.isGroupExpanding = false;
        this.transparentCardHeight = 0;
        log.showInfo(`Group item expanded, reset expand status`);
      }, NotificationGroupExpandAnimation.duration);
    }
  };
  private onExtraNtfCollapseEvent = (event: ExtraNtfCollapseEvent) => {
    if (!this.isExtraNtfsCollapsed) {
      this.isNeedGeometryTransition = false;
    }
  };

  /**
   * 释放多个参数对象
   */
  private releaseNtfListContentObj(deleteItems: Array<NotificationEntry>) {
    deleteItems?.forEach(deleteItem => {
      const groupTypeKey = deleteItem.getGroupTypeKey();
      this.ntfAnimationParas.delete(groupTypeKey);
      this.listItemModifier.delete(groupTypeKey);
      this.borderRadiusMap.delete(groupTypeKey);
      this.opacityAnimCountRecords.delete(groupTypeKey);
    })
    log.showInfo(`release NtfListContent map ${deleteItems.length} ${this.ntfAnimationParas.size} ${this.listItemModifier.size} ${this.borderRadiusMap.size} ${this.opacityAnimCountRecords.size}`);
  }

  /**
   * 获取最后一个卡片索引（通知展开期间索引不更新，但是需要处理堆叠，因此获取正确的lastIndex）
   * @returns
   */
  private getLastIndex(): number {
    return this.isGroupExpanding ? this.tempLastIndex : this.lastIndex;
  }

  private refreshExtraNtfMinHeight(): void {
    this.extraNtfMinHeight = LengthMetrics.resource($r('app.float.single_item_card_margin')).value +
      this.fontScaleState.getFontScale() * LengthMetrics.resource($r('app.float.ntf_text_line_height')).value * 2;
  }

  // 计算更多通知展开之后可见通知数量
  calExtraNtfVisibleCount = (): number => {
    let extraHeaderRectInfo: RectResult | undefined;
    try {
      extraHeaderRectInfo = this.listScroller?.getScroller().getItemRect(this.getExtraHeaderIndex());
    } catch (error) {
      log.showError(`getItemRect failed, err:${error}`);
      extraHeaderRectInfo = undefined;
    }
    if (!extraHeaderRectInfo || !extraHeaderRectInfo.height || !this.extraNtfMinHeight) {
      return 0;
    }
    // 已经占用的高度
    const usedHeight = extraHeaderRectInfo.y + extraHeaderRectInfo.height;
    // 更多通知可使用的高度
    const extraNtfHeight = (this.listRectInfo?.height ?? 0) - usedHeight;
    const extraNtfVisibleCount = Math.ceil(extraNtfHeight / (this.extraNtfMinHeight + 8));
    if (extraNtfVisibleCount < EXTRA_NTF_EXPAND_DEFAULT_SHOW_COUNT) {
      return EXTRA_NTF_EXPAND_DEFAULT_SHOW_COUNT;
    }
    return extraNtfVisibleCount;
  }
  private isAllowSwitch = (eventPosY: number, eventPosX: number) => {
    // 判断点击的是否为更多通知标题区域
    if (this.isInExtraHeaderArea(eventPosY)) {
      return true;
    }
    // 判断是否点击的第一张
    if (this.isInFirstItemWithLowOpacityArea(eventPosY)) {
      return true;
    }
    return this.isInAllowSwitchArea(eventPosY, eventPosX);
  }

  private isInExtraHeaderArea(eventPosY: number): boolean {
    if (this.extraNtfList.length === 0 || !this.extraNtfList[0]) {
      return false;
    }
    const rectInfo = this.getRectInfoById(NotificationConstants.NTF_CENTER_EXTRA_HEADER_COMP_ID);
    return eventPosY <= rectInfo.bottom && eventPosY >= rectInfo.top;
  }

  private isInFirstItemWithLowOpacityArea(eventPosY: number): boolean {
    let groupKey = this.getListItemKey(this.firstIndex);
    if (!groupKey) {
      return false;
    }
    const itemOpacity = this.ntfAnimationParas.get(groupKey)?.clearAnimOpacity ?? 1;
    if (itemOpacity >= OPACITY_THRESHOLD) {
      // 透明度大于等于0.8时，不允许滑动
      return false;
    }
    // 查询后一张卡片的顶部位置
    groupKey = this.getListItemKey(this.firstIndex + 1);
    if (!groupKey) {
      return false;
    }
    return eventPosY < this.getRectInfoById(groupKey).top;
  }

  private isInAllowSwitchArea(eventPosY: number, eventPosX: number): boolean {
    for (let i = this.lastIndex; i >= this.firstIndex; i--) {
      const groupKey = this.getListItemKey(i);
      if (!groupKey || groupKey === TRANSPARENT_CARD_ID ||
        groupKey === NotificationConstants.NTF_CENTER_EXTRA_HEADER_COMP_ID) {
        continue;
      }
      const itemOpacity = this.ntfAnimationParas.get(groupKey)?.clearAnimOpacity ?? 0;
      // 如果通知卡片的透明度小于0.8，则允许左滑切到控制中心
      if (itemOpacity >= OPACITY_THRESHOLD) {
        return !this.isInNtfVisibleList(eventPosY, eventPosX, i);
      }
    }
    return true;
  }

  // 更新顶部、底部通知param，用于判断是否进行裁剪计算
  private updateTopAndBottomAnimParams(firstIndex: number, lastIndex: number) {
    const lastGroupKey: string | undefined = this.getListItemKey(lastIndex);
    if (lastGroupKey) {
      const lastNtfAnimationParam = this.ntfAnimationParas.get(lastGroupKey);
      if (lastNtfAnimationParam) {
        lastNtfAnimationParam.isBottomItem = true;
      }
    }
    this.ntfAnimationParas.forEach((param, groupKey) => {
      if (groupKey !== lastGroupKey) {
        param.isBottomItem = false;
      }
    });
  }

  hideMoreNtfActionButtons = (isExtraNtfsCollapsed: boolean, useAnim: boolean = true): void => {
    if (!isExtraNtfsCollapsed || !this.displayButtonsHashCode || !this.extraNtfList.length) {
      return;
    }
    if (!this.ntfListVM?.isExtraNtf(this.displayButtonsHashCode)) {
      return;
    }
    if (useAnim) {
      animateTo({ curve: curves.interpolatingSpring(0, 1, 225, 25) }, () => {
        this.displayButtonsHashCode = '';
      })
    } else {
      this.displayButtonsHashCode = '';
    }
  }
}
