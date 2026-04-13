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

import { AttributeUpdater } from '@kit.ArkUI';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { onLineThemeUtil } from '@ohos/frameworkwrapper';
import { NumberConstants } from '@ohos/commonconstants';
import { launcherStatusUtil, PC_IN_PHONE_LIST } from '@ohos/windowscene';
import {
  EditModeUtils,
  MultiSelectManager,
  AppIconModel,
  GridLayoutItemInfo,
  EditModeConstants,
  NotHarmonyUtil
} from '../../TsIndex';
import { AppItemInfo } from '../../bean/AppItemInfo';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { StyleConstants } from '../../constants/StyleConstants';
import { PresetStyleConstants } from '../../constants/PresetStyleConstants';
import { AppStatus, CommonConstants, DeviceState, IconCanvasType } from '../../constants/CommonConstants';
import { AppName } from '../../uicomponents/AppName';
import { CustomBadge } from '../../uicomponents/CustomBadge';
import { MultiSelectCheckboxView } from '../../editmode/view/MultiSelectCheckboxView';
import { BooleanState } from '../../editmode/data/MultiSelectData';
import { MultiSelectStyleConfig } from '../../editmode/data/MultiSelectStyleConfig';
import { AppIconConfig } from '../config/AppIconConfig';
import { AppIconContainerModifier } from '../interface/AppIconContainerModifier';
import { AppIconDefaultModifier } from '../interface/AppIconDefaultModifier';
import { AppNameVm } from '../viewmodel/AppNameVm';
import { AppIconMenuVm } from '../viewmodel/AppIconMenuVm';
import { AppIconBadgeVm } from '../viewmodel/AppIconBadgeVm';
import { AppIconData } from '../viewmodel/AppIconData';
import { AppIconBackplaneVm } from '../viewmodel/AppIconBackplaneVm';
import { AppIconDisableMaskVm } from '../viewmodel/AppIconDisableMaskVm';
import { ShortcutViewModel } from '../viewmodel/ShortcutViewModel';
import { AppIconMenuEvent } from '../viewmodel/AppIconMenuEvent';
import { AppIconCommonEvent } from '../viewmodel/AppIconCommonEvent';
import { AppIconMenu } from './AppIconMenu';
import { AppInstallImage } from './AppInstallImage';
import { AppIconBackplane } from './AppIconBackplane';
import { AppIconShadowData } from '../../bean/AppIconShadowData';
import { AppIconDynamicShadowData } from '../viewmodel/AppIconDynamicShadowData';
import { AppIconSuperposeBadgeVm } from '../viewmodel/AppIconSuperposeBadgeVm';
import { AppIconStyleConfig } from '../config/AppIconStyleConfig';
import { batchUninstallChain } from '../../editmode/viewModel/batchUninstall/BatchUninstallChain';

const TAG = 'AppIconCommonView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);
const DEFAULT_SCALE: number = 1.0;

@Component
export struct AppIconCommonView {
  // 外部通用配置
  private appIconConfig: AppIconConfig = new AppIconConfig();
  // 图标事件处理类
  private iconEvent: AppIconCommonEvent = new AppIconCommonEvent();
  // 图标Modifier
  private iconModifier: AppIconDefaultModifier = new AppIconDefaultModifier();
  // 图标父组件Modifier
  private iconContainerModifier: AppIconContainerModifier = new AppIconContainerModifier();
  // 禁用蒙层Modifier
  private disableMaskModifier?: AttributeUpdater<CommonAttribute>;
  // 按压蒙层Modifier
  private touchMaskModifier?: AttributeUpdater<CommonAttribute>;

  private item: AppItemInfo = new AppItemInfo();
  private appNameVm: AppNameVm = new AppNameVm();
  private isFolderAppName: boolean = false;
  @Prop maxNameLines: number = PresetStyleConstants.DEFAULT_APP_NAME_LINES;
  private nameHeight: number = StyleConstants.DEFAULT_APP_NAME_HEIGHT;
  private nameWidth: number = StyleConstants.DEFAULT_APP_NAME_WIDTH;
  @Prop private nameSize: number = StyleConstants.DEFAULT_APP_NAME_SIZE;
  private nameMarginTop: number = PresetStyleConstants.DEFAULT_ICON_NAME_MARGIN_TOP;
  @Prop private nameFontColor: ResourceColor = '';
  @Prop private isAppNameHover: boolean = false;
  private popupOffset: Position = { x: 0, y: 8 };
  private popupPlacement: Placement = Placement.BottomLeft;
  private isContainerFocus: boolean = false;

  // 自定义图标Builder, 图标属性、事件业务侧自管理;
  @BuilderParam extendIconBuilder?: CustomBuilder;
  // 自定义角标Builder, 角标属性、事件业务侧自管理
  @BuilderParam extendBadgeBuilder?: CustomBuilder;
  // 自定义应用名称Builder, 名称属性、事件业务侧资管理
  @BuilderParam extendAppNameBuilder?: CustomBuilder;

  @State iconData: AppIconData = new AppIconData();
  @State isMultiSelectEntered: BooleanState = MultiSelectManager.getInstance().getStatus().getEnteredState();
  @Prop isSelect: boolean = false;
  @Link iconSize: number;
  @Prop @Watch('iconRadiusChange') iconRadius: number = CommonConstants.DEFAULT_ICON_RADIUS;
  @Prop isGainFocus: boolean = false;

  // 背板相关
  @State backplaneVm: AppIconBackplaneVm = new AppIconBackplaneVm();
  // 置灰蒙层相关
  @State disableMaskVm: AppIconDisableMaskVm = new AppIconDisableMaskVm();
  // 分层图标阴影相关
  @State appIconShadowData: AppIconShadowData | undefined = undefined;
  // 图标动态阴影相关
  @State appIconDynamicShadowData: AppIconDynamicShadowData | undefined = undefined;
  // 通知角标相关
  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();
  // 堆叠角标相关
  @State mSuperposeBadge: AppIconSuperposeBadgeVm = new AppIconSuperposeBadgeVm();
  // 长按菜单相关
  @State iconMenuVm: AppIconMenuVm = new AppIconMenuVm();
  // 编辑模式下拖拽卸载显示对话框
  @State isShowCancelDialog: boolean = false;
  // 拖拽启停相关
  @Prop @Watch('isEqualToDragItemChange') isDragStart: boolean;
  @Prop @Watch('onEqualToDropItemChange') isInDrag: boolean;
  // 拖拽挤位相关
  @Prop translateX: number = 0;
  @Prop translateY: number = 0;
  // 后续控制iconContainerModifier 控制，避免加入业务侧的中状态变量信息
  @StorageLink('folderStatusMenu') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('foldStatusForOuterScreen') @Watch('folderStatusChange') foldStatusForOuterScreen: number =
    DeviceState.DEFAULT_STATE;
  @StorageLink('showDesktopBadges') showDesktopBadges: boolean = true;
  private marginValue: Margin = {
    top: PresetStyleConstants.DEFAULT_ICON_NAME_GAP
  };
  private paddingValue : Padding = {
    bottom: StyleConstants.DEFAULT_2,
    top: StyleConstants.DEFAULT_2,
    left: StyleConstants.DEFAULT_2,
    right: StyleConstants.DEFAULT_2
  };

  /**
   * 从卡片管理添加一键锁屏快捷方式加桌处理
   */
  private onCreateFormShortcutHandler() {
    if (this.item.typeId !== CommonConstants.TYPE_SHORTCUT_ICON ||
      this.item.bundleName !== CommonConstants.SCENEBOARD_BUNDLE) {
      return;
    }
    if (this.isInDrag) {
      this.onEqualToDropItemChange();
      return;
    }
    this.iconEvent.onCreateFormShortcutHandler();
  }

  private iconRadiusChange(): void {
    // 更新TransitionController中圆角
    this.iconEvent.updateRadiusOfTransCtrl(this.iconRadius);
  }

  private folderStatusChange() {
    if (this.iconMenuVm.isMenuShow()) {
      this.iconMenuVm.isHiddenEffect = true;
    }
  }

  /**
   * 拖拽结束应用名渐显动效
   */
  private isEqualToDragItemChange(): void {
    // 不是拖拽卸载的场景才需要渐显动效
    if (!this.isShowCancelDialog) {
      this.iconEvent.isEqualToDragItemChange(this.isDragStart, this.isInDrag);
    }
  }

  /**
   * 拖拽落位过程中隐藏图标
   */
  private onEqualToDropItemChange(): void {
    // 不是拖拽卸载的场景才需要渐显动效
    if (!this.isShowCancelDialog) {
      this.iconEvent.onEqualToDropItemChange(this.isDragStart, this.isInDrag);
    }
  }

  private isVisible(): boolean {
    if (this.isDragStart) {
      log.showInfo('visible hidden: dragStart');
      return false;
    }

    if (this.isShowCancelDialog) {
      log.showInfo('visible hidden: showCancelDialog');
      return false;
    }

    if (!this.iconEvent.isIconContainerShow()) {
      log.showInfo('visible hidden: isIconContainerShow: false');
      return false;
    }

    return true;
  }

  private getShadowOptions(): ShadowOptions | null {
    // 动态阴影(比如PC dock)
    if (this.appIconConfig.enableShadow && this.appIconConfig.enableDynamicIconShadow &&
      this.appIconDynamicShadowData) {
      return {
        radius: this.appIconDynamicShadowData.radius,
        color: this.appIconDynamicShadowData.color,
        offsetX: this.appIconDynamicShadowData.offsetX,
        offsetY: this.appIconDynamicShadowData.offsetY
      };
    }
    // 静态阴影
    return AppIconStyleConfig.getIconShadowOptions(this.appIconConfig.enableShadow);
  }

  private getIconRadius(): number {
    if (!onLineThemeUtil.isOnlineTheme() || !GridLayoutUtil.isAppInstalled(this.item) ||
      this.appIconConfig.enableRadiusAll) {
      return this.iconRadius;
    } else {
      return 0;
    }
  }

  private getIconSize(): number | string {
    return this.appIconConfig.isAdaptiveLayout ? StyleConstants.PERCENTAGE_100 : this.iconSize;
  }

  private isSyncLoad(): boolean {
    return (typeof this.iconData.image !== 'string') || GridLayoutUtil.isImageSyncLoad(this.iconData.image as string);
  }

  private updateIsShowCancelDialog: (isShow: boolean) => void = (isShow: boolean): void => {
    this.isShowCancelDialog = isShow;
    // 取消卸载时需要恢复图标名称及角标显示
    if (!this.isShowCancelDialog) {
      this.iconEvent.isEqualToDragItemChange(this.isDragStart, this.isInDrag);
      this.iconEvent.onEqualToDropItemChange(this.isDragStart, this.isInDrag);
    }
  }

  private initComponentData(isInitIconId: boolean = true): void {
    this.isShowCancelDialog = batchUninstallChain.ifHideAppIcon(this.item as GridLayoutItemInfo);
    if (this.appIconConfig.enableShadow && this.appIconConfig.enableDynamicIconShadow) {
      this.appIconDynamicShadowData = new AppIconDynamicShadowData();
      this.appIconShadowData = new AppIconShadowData();
    }
    this.iconEvent.init({
      itemInfo: this.item,
      iconData: this.iconData,
      iconConfig: this.appIconConfig,
      iconSizeCb: () => this.iconSize,
      isInDragCb: () => this.isInDrag,
      isShowCancelDialogCb: this.updateIsShowCancelDialog,
      uiContextCb: this.getUIContext(),
      longPressImageBuilder: () => this.longPressImageBuilder(),
      dragIconBuilder: () => this.dragIconBuilder(),
      isInitIconId: isInitIconId,
      longPressMenuBuilder: () => this.longPressMenuBuilder(),
      rightClickMenuBuilder: () => this.rightClickMenuBuilder(),
      iconModifier: this.iconModifier,
      iconContainerModifier: this.iconContainerModifier,
      appNameVm: this.appNameVm,
      backplaneVm: this.backplaneVm,
      disableMaskVm: this.disableMaskVm,
      appIconShadowData: this.appIconShadowData,
      appIconDynamicShadowData: this.appIconDynamicShadowData,
      iconBadgeVm: this.iconBadgeVm,
      iconMenuVm: this.iconMenuVm,
    });
  }

  private isDisableMaskShow(): boolean {
    return this.appIconConfig.enableDisableMask && !this.isInDrag && this.disableMaskVm.visible;
  }

  private isTouchMaskShow(): boolean {
    return this.appIconConfig.enableTouchMask && !this.isInDrag && this.iconData.touchMaskVisible;
  }

  private isCustomMaskShow(): boolean {
    return this.iconData.isShowMask && !this.isInDrag;
  }

  /*
   * 是否使用overlay方式创建图标（相比于RelativeContainer, 降低节点数）
   * 适用于 只需要图标Image + 按压蒙层 的场景
   */
  private isOverlayIcon(): boolean {
    if (!this.appIconConfig.enableOverlayIcon) {
        return false;
    }
    // 分层图标不需要使用overlay
    if (this.iconData.isLayeredIcons) {
      return false;
    }
    // 使能显示名称时不需要使用overlay
    if (this.appIconConfig.enableName) {
      return false;
    }
    // 有消息角标、分身角标时不需要使用overlay
    if (this.iconBadgeVm.badgeNumber > 0 || this.item.appIndex || this.mSuperposeBadge.badgeNumber > 0) {
      return false;
    }
    // 动态图标不需要使用overlay
    if (this.iconData.isDynamicIcon) {
      return false;
    }
    if (PC_IN_PHONE_LIST.includes(this.item.bundleName) ||
      NotHarmonyUtil.isWaitingDownloadApp(this.item)) {
      return false;
    }
    // 有禁用、下载、自定义蒙层的图标不需要使用overlay
    if (this.isDisableMaskShow() || this.isShowInstallImage() || this.isCustomMaskShow()) {
      return false;
    }
    log.showInfo(`build overlay icon bundleName: ${this.item.bundleName}`);
    return true;
  }

  private getContainerComponentId(): string {
    if (this.appIconConfig.isOuterDesktop) {
      return `${TAG}_OuterDesktop_${this.item.bundleName}.${this.item.abilityName}`;
    }
    return `${TAG}_${this.item.bundleName}.${this.item.abilityName}`;
  }

  private isShowInstallImage(): boolean {
    if (this.item.typeId === CommonConstants.TYPE_SHORTCUT_ICON && this.item.appStatus === AppStatus.PENDING) {
      return false;
    }
    const itemShow = this.appIconConfig.enableInstallAnimate &&
      ((!GridLayoutUtil.isAppInstalled(this.item) && this.iconEvent.isIconShow() && !this.isInDrag) ||
      this.item.appStatus === AppStatus.UPDATING || this.item.appStatus === AppStatus.WAIT_FOR_HARMONY);
    if (itemShow || (this.item.appStatus === this.iconData.appStatus)) {
      // item是常态, 数据是准确的, 或者两者状态相同, 取itemShow.
      return itemShow;
    }
    // iconData.appStatus只会在下载蒙层场景下触发, 兜底额外判断iconData中下载状态是否需要施加蒙层
    return this.appIconConfig.enableInstallAnimate &&
      (((this.iconData.appStatus !== AppStatus.INSTALLED) && this.iconEvent.isIconShow() && !this.isInDrag) ||
        this.iconData.appStatus === AppStatus.UPDATING || this.iconData.appStatus === AppStatus.WAIT_FOR_HARMONY);
  }

  private handleContainerOnClickEvent = (event: ClickEvent) => {
    if (this.isContainerFocus) {
      // 键盘获焦时点击事件默认使用getIconTouchEventIface的onClick响应图标点击
      this.iconEvent.getIconTouchEventIface()?.onClick();
      return;
    }
    this.iconEvent.getIconContainerEventIface()?.onClick(event);
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear ${this.item.bundleName}.`);
    this.initComponentData();
    this.onCreateFormShortcutHandler();
  }

  aboutToReuse(params: Record<string, Object>): void {
    let oldBundleName: string = this.item.bundleName;
    this.item = params.item as AppItemInfo;
    log.showInfo(`aboutToReuse from ${oldBundleName} -> ${this.item.bundleName}.`);
    if (this.appIconConfig.isReuseIconConfigAndEvent) {
      const appIconConfig = params.appIconConfig as AppIconConfig;
      if (appIconConfig) {
        this.appIconConfig = appIconConfig;
      }
      const iconEvent = params.iconEvent as AppIconCommonEvent;
      if (iconEvent) {
        this.iconEvent = iconEvent;
      }
      log.showDebug(`isReuseIconConfigAndEvent :${this.item.bundleName},${this.appIconConfig.isReuseIconConfigAndEvent}.`);
    }
    // initComponentData里边存在异步，无法在aboutToReuse里刷新UI，setTimeout 0 提供一个新管道刷新
    setTimeout(() => {
      this.initComponentData(false);
    }, 0);
  }

  aboutToRecycle(): void {
    log.showInfo(`aboutToRecycle ${this.item.bundleName}.`);
    this.aboutToDisappear();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear ${this.item.bundleName}.`);
    this.iconEvent.destroy();
  }

  private isShowCustomBadge(): boolean {
    return this.showDesktopBadges && this.iconBadgeVm.enable && this.iconBadgeVm.badgeNumber > 0 &&
      !this.isDragStart && this.item.typeId !== CommonConstants.TYPE_SHORTCUT_ICON &&
      !AppIconStyleConfig.getIconBadgeInvisible(this.item.bundleName);
  }

  @Styles
  basicIconStyles() {
    .width(this.getIconSize())
    .height(this.getIconSize())
    .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
    .scale({ x: this.iconData.iconScale, y: this.iconData.iconScale })
    // 连续启动打断场景无法使用visible控制
    .opacity(this.iconData.iconOpacity)
    .borderRadius(this.getIconRadius())
    .shadow(this.getShadowOptions())
    .backgroundImage(ShortcutViewModel.getInstance().getShortcutBackgroundImage(this.item),
      { syncLoad: true } as BackgroundImageOptions)
    .backgroundImageSize(ImageSize.Cover)
    .backgroundImagePosition(Alignment.Center)
    // 触摸热区外扩8vp, 配置能力支持热区扩展 8vp
    .responseRegion(this.appIconConfig.enableExtendResponseRegion ? {
      x: -StyleConstants.APP_ICON_RESPONSE_REGION_EXTEND_LENGTH,
      y: -StyleConstants.APP_ICON_RESPONSE_REGION_EXTEND_LENGTH,
      width: this.iconSize + (StyleConstants.APP_ICON_RESPONSE_REGION_EXTEND_LENGTH * 2),
      height: this.iconSize + (StyleConstants.APP_ICON_RESPONSE_REGION_EXTEND_LENGTH * 2)
    } : {
      x: 0,
      y: 0,
      width: StyleConstants.PERCENTAGE_100,
      height: StyleConstants.PERCENTAGE_100
    })
    .onClick((): void => this.iconEvent.getIconTouchEventIface()?.onClick())
    .accessibilityLevel('no')
    .id(this.iconData.iconId)
    .alignRules(this.appIconConfig.alignRuleOption ? this.appIconConfig.alignRuleOption : {
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      top: { anchor: '__container__', align: VerticalAlign.Top },
    })
    .onTouch((event: TouchEvent): void => this.iconEvent.getIconTouchEventIface()?.onTouch(event))
    .onHover((isHover: boolean, event: HoverEvent): void => this.iconEvent.getIconHoverEventIface()?.onHover(isHover,
      event, (scale: number) => { this.iconData.containerScale = scale; }))
    .onMouse((event: MouseEvent): void => this.iconEvent.getIconMouseEventIface()?.onMouse(event))
    .onPreDrag((preDragStatus: PreDragStatus) => this.iconEvent.getIconDragEventIface()?.onPreDrag(preDragStatus))
    .focusable(false)
  }

  @Styles
  longPressGestureStyles() {
    .parallelGesture(
      GestureGroup(GestureMode.Parallel,
        // 100ms 空长按手势确保图标优先于编辑模式背板响应长按手势
        LongPressGesture({ repeat: false, duration: EditModeConstants.PAGE_DRAG_SKIP_GESTURE_TIME}),
        // 300ms 多选长按预汇聚
        LongPressGesture({ repeat: false, duration: MultiSelectStyleConfig.LONG_PRESS_TIME_OF_PRE_GATHER })
          .onAction((event: GestureEvent) => {
            this.iconEvent.getLongPressGestureEventIface()?.onLongPressPreGatherAction(event);
          })
          .onActionEnd((event:GestureEvent) => {
            this.iconEvent.getLongPressGestureEventIface()?.onLongPressPreGatherActionEnd(event);
          }),
        // 350ms 单选长按截图
        LongPressGesture({ repeat: false, duration: CommonConstants.LONG_PRESS_TIME_FOR_SNAPSHOT })
          .onAction((event: GestureEvent) => {
            this.iconEvent.getLongPressGestureEventIface()?.onLongPressSnapshotAction(event);
          })
          .onActionCancel(() => {
            this.iconEvent.getLongPressGestureEventIface()?.onLongPressSnapshotActionCancel();
          })
          .onActionEnd((event: GestureEvent) => {
            this.iconEvent.getLongPressGestureEventIface()?.onLongPressSnapshotActionEnd(event);
          }),
        // 400ms 长按多选汇聚
        LongPressGesture({ repeat: false, duration: MultiSelectStyleConfig.LONG_PRESS_TIME_OF_GATHER })
          .onAction((event: GestureEvent) => {
            this.iconEvent.getLongPressGestureEventIface()?.onLongPressGatherAction(event);
          })
          .onActionEnd((event: GestureEvent): void => {
            this.iconEvent.getLongPressGestureEventIface()?.onLongPressGatherActionEnd(event);
          }),
        // 500ms 长按震动
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_VIBRATOR_TIME })
          .onAction((event: GestureEvent): void => {
            this.iconEvent.getLongPressGestureEventIface()?.onLongPressVibrateAction(event);
          })
          .onActionEnd((event: GestureEvent): void => {
            this.iconEvent.getLongPressGestureEventIface()?.onLongPressVibrateActionEnd(event);
            if (!this.isInDrag) {
              MultiSelectManager.getInstance().finishSingleDrag();
            }
          })
          .onActionCancel((): void => {
            this.iconEvent.getLongPressGestureEventIface()?.onLongPressVibrateActionCancel();
          }),
        // 550ms 长按放大动效
        LongPressGesture({ repeat: false, duration: NumberConstants.LONG_PRESS_ZOOM_IN })
          .onAction((event: GestureEvent): void => {
            this.iconEvent.getLongPressGestureEventIface()?.onLongPressZoomInAction(event);
          }),
      ),
    )
  }

  @Styles
  dragStyles() {
    .draggable(this.appIconConfig.enableDrag && this.iconData.enableDrag)
    .onDragStart((event: DragEvent) => { return this.iconEvent.getIconDragEventIface()?.onDragStart(event); })
    .onDragEnd((event: DragEvent) => this.iconEvent.getIconDragEventIface()?.onDragEnd(event))
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      return this.iconEvent.getIconGestureJudgeIface()?.onGestureJudgeBegin(gestureInfo, event);
    })
    .dragPreviewOptions({}, {
      isDragPreviewEnabled: false,
    })
  }

  @Styles
  bindMenuStyles() {
    .bindContextMenu(this.iconEvent.getIconRightClickContextMenuIface()?.showContextMenu() ?
        this.rightClickMenuBuilder : (): void => {},
      ResponseType.RightClick,
      this.iconEvent.getIconRightClickContextMenuIface()?.getRightClickMenuOptions(this.iconMenuVm.menuPlacement))
    .bindContextMenu(this.iconMenuVm.isMenuShow(),
      this.iconEvent.getIconLongPressContextMenuIface()?.showContextMenu() ? this.longPressMenuBuilder : (): void => {},
      this.iconEvent.getIconLongPressContextMenuIface()?.getLongPressMenuOptions())
  }

  @Builder
  dragIconBuilder() {
    Stack() {
      if (!this.iconData.isDynamicIcon) {
        Image(this.iconData.image)
          .draggable(false)
          .width(EditModeUtils.convertWithDesktopScale(this.iconSize))
          .height(EditModeUtils.convertWithDesktopScale(this.iconSize))
          .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
          .borderRadius(EditModeUtils.convertWithDesktopScale(this.iconRadius))
          .syncLoad(this.isSyncLoad())
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false)
          .scale(AppIconModel.getInstance().getDragIconBuilderScale(this.item))
          .backgroundImage(ShortcutViewModel.getInstance().getShortcutBackgroundImage(this.item),
            { syncLoad: true } as BackgroundImageOptions)
          .backgroundImageSize(ImageSize.Cover)
          .backgroundImagePosition(Alignment.Center)
          .onError((error: ImageError) => this.iconEvent.showImageErrorMessage(error))
      }
      if (this.disableMaskVm.visible) {
        Canvas(this.iconEvent.getIconMaskCanvas(IconCanvasType.DRAG_MASK)?.getContext())
          .onReady(() => {
            this.iconEvent.getIconMaskCanvas(IconCanvasType.DRAG_MASK)?.updateMask(this.iconData.image,
              EditModeUtils.convertWithDesktopScale(this.iconSize), this.item);
          })
          .onDisAppear(() => {
            this.iconEvent.releaseIconCanvas(IconCanvasType.DRAG_MASK);
          })
          .width(EditModeUtils.convertWithDesktopScale(this.iconSize))
          .height(EditModeUtils.convertWithDesktopScale(this.iconSize))
          .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
          .id(this.iconEvent.getIconMaskCanvas(IconCanvasType.DRAG_MASK)?.getCanvasId())
      }
    }
    .borderRadius(EditModeUtils.convertWithDesktopScale(this.iconRadius))
    .clip(true)
  }

  @Builder
  contextMenuBuilder(isLongPress: boolean) {
    AppIconMenu({
      isLongPressShow: isLongPress,
      appIconId: this.iconData.iconId,
      iconMenuVm: this.iconMenuVm,
      iconMenuEvent: this.iconEvent.getIconMenuEvent() as AppIconMenuEvent,
      iconSize: this.iconSize,
      iconRadius: this.iconRadius,
      dragStart: this.appIconConfig.externCb?.onMenuDragStart,
      appItem: this.item,
      isOuterDesktop: this.appIconConfig.isOuterDesktop,
      appIconConfig: this.appIconConfig
    })
  }

  @Builder
  longPressMenuBuilder() {
    this.contextMenuBuilder(true);
  }

  @Builder
  rightClickMenuBuilder() {
    this.contextMenuBuilder(false);
  }

  @Builder
  longPressImageBuilder() {
    Stack() {
      if (!GridLayoutUtil.isAppInstalled(this.item)) {
        Image(this.iconData.image ? this.iconData.image : this.item.iconResource)
          .width(this.iconSize)
          .height(this.iconSize)
          .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
          .syncLoad(GridLayoutUtil.isImageSyncLoad(this.item.iconResource ?? ''))
          .interpolation(ImageInterpolation.Medium)
          .backgroundImage(ShortcutViewModel.getInstance().getShortcutBackgroundImage(this.item),
            { syncLoad: true } as BackgroundImageOptions)
          .backgroundImageSize(ImageSize.Cover)
          .backgroundImagePosition(Alignment.Center)
          .autoResize(false)
      } else {
        if (!this.iconData.isDynamicIcon) {
          Image(this.iconData.image)
            .draggable(false)
            .width(this.iconSize)
            .height(this.iconSize)
            .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
            .syncLoad(true)
            .interpolation(ImageInterpolation.Medium)
            .autoResize(false)
            .backgroundImage(ShortcutViewModel.getInstance().getShortcutBackgroundImage(this.item),
              { syncLoad: true } as BackgroundImageOptions)
            .backgroundImageSize(ImageSize.Cover)
            .backgroundImagePosition(Alignment.Center)
            .onError((error: ImageError) => this.iconEvent.showImageErrorMessage(error))
            .id('LongPressImage')
        }
      if (this.disableMaskVm.visible) {
        Canvas(this.iconEvent.getIconMaskCanvas(IconCanvasType.LONG_PRESS_MASK)?.getContext())
          .onReady(() => {
            this.iconEvent.getIconMaskCanvas(IconCanvasType.LONG_PRESS_MASK)?.updateMask(this.iconData.image,
              this.iconSize, this.item);
          })
          .onDisAppear(() => {
            this.iconEvent.releaseIconCanvas(IconCanvasType.LONG_PRESS_MASK);
          })
          .width(this.iconSize)
          .height(this.iconSize)
          .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
          .id(this.iconEvent.getIconMaskCanvas(IconCanvasType.LONG_PRESS_MASK)?.getCanvasId())
        }
      }
      this.touchMaskInMenuPreview()
    }
    .borderRadius(this.iconRadius)
    .clip(true)
  }

  @Builder
  touchMaskInMenuPreview() {
    if (this.appIconConfig.enableTouchMask) {
      Canvas(this.iconEvent.getIconMaskCanvas(IconCanvasType.PRESS_MASK)?.getContext())
        .onReady(() => {
          this.iconEvent.getIconMaskCanvas(IconCanvasType.PRESS_MASK)?.updateMask(this.iconData.image, this.iconSize,
            this.item);
        })
        .width(this.iconSize)
        .height(this.iconSize)
        .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
        .opacity(this.iconMenuVm.previewMaskOpacity)
        .enabled(false)
        .onAppear(() => {
          this.iconEvent.getIconMenuEvent()?.previewMaskAnim();
        })
        .onDisAppear(() => {
          this.iconEvent.releaseIconCanvas(IconCanvasType.PRESS_MASK);
        })
        .id(this.iconEvent.getIconMaskCanvas(IconCanvasType.PRESS_MASK)?.getCanvasId())
    }
  }

  @Builder
  LayeredIconsBuilder() {
    Stack() {
      Image(this.iconData.backgroundImagePixel)
        .draggable(false)
        .height(this.iconData.isHighResolutionImage ? this.iconSize :
          this.iconSize * NumberConstants.CONSTANT_ADAPTIVE_SCALE)
        .width(this.iconData.isHighResolutionImage ? this.iconSize :
          this.iconSize * NumberConstants.CONSTANT_ADAPTIVE_SCALE)
        .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
        .syncLoad(true)
        .interpolation(ImageInterpolation.Low)
        .backgroundImage(ShortcutViewModel.getInstance().getShortcutBackgroundImage(this.item))
        .id(`${TAG}_Image_${this.item.bundleName}_background`)
      Image(this.iconData.shadowImagePixel)
        .draggable(false)
        .height(this.iconData.isHighResolutionImage ? this.iconSize :
          this.iconSize * NumberConstants.CONSTANT_ADAPTIVE_SCALE)
        .width(this.iconData.isHighResolutionImage ? this.iconSize :
          this.iconSize * NumberConstants.CONSTANT_ADAPTIVE_SCALE)
        .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
        .syncLoad(true)
        .interpolation(ImageInterpolation.Low)
        .scale({ x: this.appIconShadowData?.shadowScale, y: this.appIconShadowData?.shadowScale })
        .opacity(this.appIconShadowData?.shadowOpacity)
        .translate({
          x: this.appIconShadowData?.shadowTranslateX,
          y: this.appIconShadowData?.shadowTranslateY,
        })
        .rotate({
          x: this.appIconShadowData?.shadowRotateX,
          y: this.appIconShadowData?.shadowRotateY,
          z: 0,
          centerX: '50%',
          centerY: '50%',
          perspective: -1.5,
          angle: this.appIconShadowData?.shadowRotateAngle
        })
        .id(`${TAG}_Image_${this.item.bundleName}_shadow`)
      Image(this.iconData.foregroundImagePixel)
        .draggable(false)
        .height(this.iconData.isHighResolutionImage ? this.iconSize :
          this.iconSize * NumberConstants.CONSTANT_ADAPTIVE_SCALE)
        .width(this.iconData.isHighResolutionImage ? this.iconSize :
          this.iconSize * NumberConstants.CONSTANT_ADAPTIVE_SCALE)
        .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
        .syncLoad(true)
        .interpolation(ImageInterpolation.Medium)
        .objectFit(ImageFit.Contain)
        .autoResize(false)
        .translate({
          x: this.appIconShadowData?.foregroundTranslateX,
          y: this.appIconShadowData?.foregroundTranslateY,
        })
        .id(`${TAG}_Image_${this.item.bundleName}_foreground`)
    }
    .clip(true)
    .basicIconStyles()
    .dragStyles()
    .longPressGestureStyles()
    .bindMenuStyles()
    .attributeModifier(this.iconModifier)
  }

  @Builder
  appIconBuilder() {
    if (this.extendIconBuilder) {
      Stack() {
        this.extendIconBuilder()
      }
      .basicIconStyles()
      .attributeModifier(this.iconModifier)
    } else if (this.iconData.isLayeredIcons) {
      this.LayeredIconsBuilder()
    } else {
      if (!this.iconData.isDynamicIcon) {
        Image(this.iconData.image)
          .syncLoad(this.isSyncLoad())
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false)
          .basicIconStyles()
          .longPressGestureStyles()
          .dragStyles()
          .bindMenuStyles()
          .onError((error: ImageError) => this.iconEvent.showImageErrorMessage(error))
          .attributeModifier(this.iconModifier)
      }
    }
  }

  /**
   * 按压蒙层
   * @param isNeedScale 蒙层是否需要缩放
   */
  @Builder
  touchMaskBuilder(isNeedScale: boolean = true) {
    if (this.isTouchMaskShow()) {
      Canvas(this.iconEvent.getIconMaskCanvas(IconCanvasType.TOUCH_MASK)?.getContext())
        .onReady(() => {
          this.iconEvent.getIconMaskCanvas(IconCanvasType.TOUCH_MASK)?.updateMask(this.iconData.image, this.iconSize,
            this.item);
        })
        .onDisAppear(() => {
          this.iconEvent.releaseIconCanvas(IconCanvasType.TOUCH_MASK);
        })
        .width(this.getIconSize())
        .height(this.getIconSize())
        .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
        .scale(isNeedScale ? { x: this.iconData.iconScale, y: this.iconData.iconScale } :
          { x: DEFAULT_SCALE, y: DEFAULT_SCALE })
        .visibility(this.iconEvent.isIconShow() ? Visibility.Visible : Visibility.Hidden)
        .enabled(false)
        .alignRules({
          middle: { anchor: this.iconData.iconId, align: HorizontalAlign.Center },
          center: { anchor: this.iconData.iconId, align: VerticalAlign.Center },
        })
        .id(this.iconEvent.getIconMaskCanvas(IconCanvasType.TOUCH_MASK)?.getCanvasId())
        .attributeModifier(this.touchMaskModifier)
        .borderRadius(this.getIconRadius())
        .clip(true)
    }
  }

  @Builder
  customMaskBuilder(isNeedScale: boolean = true) {
    if (this.isCustomMaskShow()) {
      Canvas(this.iconEvent.getIconMaskCanvas(IconCanvasType.CUSTOM_MASK)?.getContext())
        .onReady(() => {
          this.iconEvent.getIconMaskCanvas(IconCanvasType.CUSTOM_MASK)?.setFillStyle(this.iconData.maskBgColor)
          this.iconEvent.getIconMaskCanvas(IconCanvasType.CUSTOM_MASK)?.updateMask(this.iconData.image, this.iconSize,
            this.item);
        })
        .onDisAppear(() => {
          this.iconEvent.releaseIconCanvas(IconCanvasType.CUSTOM_MASK);
        })
        .width(this.iconSize)
        .height(this.iconSize)
        .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
        .scale(isNeedScale ? { x: this.iconData.iconScale, y: this.iconData.iconScale } :
          { x: DEFAULT_SCALE, y: DEFAULT_SCALE })
        .opacity(this.iconData.maskOpacity)
        .enabled(false)
        .alignRules({
          center: { anchor: this.iconData.iconId, align: VerticalAlign.Center },
          middle: { anchor: this.iconData.iconId, align: HorizontalAlign.Center },
        })
        .id(this.iconEvent.getIconMaskCanvas(IconCanvasType.CUSTOM_MASK)?.getCanvasId())
        .borderRadius(this.getIconRadius())
        .clip(true)
    }
  }

  @Builder
  installImageBuilder(isNeedScale: boolean = true) {
    if (this.isShowInstallImage()) {
      AppInstallImage({
        appIconId: this.iconData.iconId,
        itemInfo: this.item,
        iconSize: this.iconSize,
        iconRadius: this.iconRadius,
        iconScale: isNeedScale ? this.iconData.iconScale : DEFAULT_SCALE,
        iconOpacity: this.iconData.iconOpacity,
        isAdaptiveExtendLayout: this.appIconConfig.isAdaptiveLayout,
        isLongPressHideMask: this.iconData.isLongPressHideMask,
        isOuterDesktop: this.appIconConfig.isOuterDesktop,
        onItemAppStatusChange: (status: AppStatus): void => {
          this.iconEvent.onItemAppStatusChange(status);
        }
      })
    }
  }

  @Builder
  badgeBuilder() {
    if (this.appIconConfig.enableBadge) {
      if (!this.isDragStart && this.iconBadgeVm.isCustom && this.extendBadgeBuilder) {
        this.extendBadgeBuilder()
      } else if (this.isShowCustomBadge()) {
        CustomBadge({
          ratio: this.iconBadgeVm.ratio,
          keyName: this.item.keyName,
          badgeNumber: this.iconBadgeVm.badgeNumber,
          iconSize: this.iconSize,
          isBadgeSmaller: this.appIconConfig.isBadgeSmaller,
          bindFolderId: this.iconBadgeVm.bindFolderId,
          isSuperposeApp: this.iconBadgeVm.isSuperposeApp,
          isUpdateSuperposeBadge: this.iconBadgeVm.isUpdateSuperposeBadge,
          badgeVisible: (!this.iconEvent.isIconShow() || this.isInDrag) ? false : this.iconBadgeVm.visible,
          badgeAnimate: this.iconBadgeVm.animate,
          bundleName: this.item.bundleName,
          iconId: this.iconData.iconId,
          startType: this.appIconConfig?.appDataOfTransitionController?.startAppType,
          alignOption: {
            right: { anchor: this.iconData.iconId, align: HorizontalAlign.End },
            top: { anchor: this.iconData.iconId, align: VerticalAlign.Top }
          },
          modifier: this.iconBadgeVm.modifier,
          appIndex: this.item.appIndex,
        })
      }
    }
  }

  @Builder
  superPoseBadgeBuilder() {
    // 堆叠应用总角标, 涉及到文件夹重构，后续要整改掉
    if (this.showDesktopBadges && this.appIconConfig.enableSuperPoseBadge && this.iconEvent.isIconShow() &&
      !this.isInDrag &&
      this.mSuperposeBadge.badgeNumber > 0) {
      CustomBadge({
        keyName: this.item.keyName,
        badgeNumber: this.mSuperposeBadge.badgeNumber,
        iconSize: this.mSuperposeBadge.iconSize,
        bindFolderId: this.mSuperposeBadge.bindFolderId,
        isSuperposeApp: true,
        badgeAnimate: this.mSuperposeBadge.badgeAnimate,
        badgeOpacity: this.mSuperposeBadge.badgeOpacity,
        badgeScale: this.mSuperposeBadge.badgeScale,
        badgeVisible: this.mSuperposeBadge.badgeVisible,
        isIgnoreDesktopModeChange: true,
        bundleName: this.item.bundleName,
        alignOption: {
          right: { anchor: this.iconData.iconId, align: HorizontalAlign.End },
          top: { anchor: this.iconData.iconId, align: VerticalAlign.Top }
        },
        appIndex: this.item.appIndex,
      })
    }
  }

  @Builder
  multiCheckboxBuilder() {
    if (this.isMultiSelectEntered.value && this.appIconConfig.enableMultiSelect &&
    launcherStatusUtil.isCurrentDesktopVisible(this.appIconConfig.isOuterDesktop)) {
      MultiSelectCheckboxView({
        iconSize: this.iconSize,
        parentId: MultiSelectManager.getInstance().getUniqueId(this.item),
        rectId: this.iconData.iconId,
        parentType: this.iconEvent.getMultiSelectIconType(),
        parentItemInfo: this.item,
        radius: this.iconRadius,
        isInDrag: this.isInDrag,
        isShowCancelDialog: this.isShowCancelDialog,
        isOuterDesktop: this.appIconConfig.isOuterDesktop,
        checkboxOpacity: this.iconData.checkboxOpacity,
      })
    }
  }

  @Builder
  appNameBuilder() {
    if (this.appIconConfig.enableName) {
      // 外部扩展AppNameBuilder
      if (this.extendAppNameBuilder) {
        this.extendAppNameBuilder()
      } else {
        AppName({
          nameHeight: this.nameHeight,
          nameWidth: this.nameWidth,
          nameSize: this.nameSize,
          nameFontColor: this.nameFontColor,
          bundleName: this.item.bundleName,
          moduleName: this.item.moduleName,
          parentItem: this.item,
          appName: this.appIconConfig.externCb?.getAppName?.() ?? this.item.appName,
          labelId: this.item.appLabelId,
          useCache: true,
          maxLines: this.maxNameLines,
          marginTop: this.nameMarginTop,
          isDesktopItem: this.appIconConfig.isDesktopItem,
          colStart: this.item.column,
          colEnd: this.item.column,
          rowEnd: this.item.row,
          // PC应用中心为true
          isSingleShadow: false,
          getIndexInSwiper: this.appIconConfig.externCb?.getIndexInSwiper,
          itemStatus: this.item?.appStatus,
          isSelect: this.isSelect,
          isGainFocus: this.isGainFocus,
          nameBackgroundColor: StyleConstants.DEFAULT_DESKTOP_BACKGROUND_COLOR,
          zValue: -1,
          iconId: this.iconData.iconId,
          iconRadius: this.iconRadius,
          appIconConfig: this.appIconConfig,
          iconEvent: this.iconEvent,
          alignOption: {
            top: { anchor: this.iconData.iconId, align: VerticalAlign.Bottom },
            middle: { anchor: this.iconData.iconId, align: HorizontalAlign.Center }
          },
          isFolderAppName: this.isFolderAppName,
          modifier: this.appNameVm.modifier,
          isAppNameHover: this.isAppNameHover,
          popupOffset: this.popupOffset,
          popupPlacement: this.popupPlacement,
          marginValue: this.marginValue,
          paddingValue: this.paddingValue,
          mOpacity: this.iconData.nameOpacity,
        })
      }
    }
  }

  @Builder
  appIconBackplaneBuilder() {
    if (this.backplaneVm.visible && this.appIconConfig.enableBackplane) {
      AppIconBackplane({
        appIconId: this.iconData.iconId,
        backplaneSize: this.iconSize + this.appIconConfig.iconBackPlaneSize,
        backplaneRadius: this.iconRadius,
        backplaneVm: this.backplaneVm,
      });
    }
  }

  @Builder
  disableMaskBuilder(isNeedScale: boolean = true) {
    if (this.isDisableMaskShow()) {
      Canvas(this.iconEvent.getIconMaskCanvas(IconCanvasType.DISABLE_MASK)?.getContext())
        .onReady(() => {
          this.iconEvent.getIconMaskCanvas(IconCanvasType.DISABLE_MASK)?.updateMask(this.iconData.image, this.iconSize,
            this.item);
        })
        .onDisAppear(() => {
          this.iconEvent.releaseIconCanvas(IconCanvasType.DISABLE_MASK);
        })
        .width(this.getIconSize())
        .height(this.getIconSize())
        .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
        .scale(isNeedScale ? { x: this.iconData.iconScale, y: this.iconData.iconScale } :
          { x: DEFAULT_SCALE, y: DEFAULT_SCALE })
        .opacity(this.iconData.iconOpacity)
        .enabled(false)
        .alignRules(this.appIconConfig.alignRuleOption ? this.appIconConfig.alignRuleOption : {
          middle: { anchor: this.iconData.iconId, align: HorizontalAlign.Center },
          center: { anchor: this.iconData.iconId, align: VerticalAlign.Center },
        })
        .id(this.iconEvent.getIconMaskCanvas(IconCanvasType.DISABLE_MASK)?.getCanvasId())
        .attributeModifier(this.disableMaskModifier)
        .borderRadius(this.getIconRadius())
        .margin({
          top: this.appIconConfig.iconMarginTop,
        })
        .clip(true)
    }
  }

  @Builder
  overlayIcon() {
    Image(this.iconData.image)
      .syncLoad(this.isSyncLoad())
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
      .basicIconStyles()
      .longPressGestureStyles()
      .dragStyles()
      .bindMenuStyles()
      .onError((error: ImageError) => this.iconEvent.showImageErrorMessage(error))
      .attributeModifier(this.iconModifier)
      .overlay(this.overlayMaskBuilder, { align: Alignment.Center })
      .translate({ x: this.iconData.transX, y: this.iconData.transY })
      .offset({ x: this.iconData.offsetX, y: this.iconData.offsetY })
  }

  @Builder
  overlayMaskBuilder() {
    Stack({ alignContent: Alignment.Center }) {
      // 按压蒙层
      this.touchMaskBuilder(false);
    }
    .visibility(this.isTouchMaskShow() ? Visibility.Visible : Visibility.Hidden)
  }

  build() {
    if (this.isOverlayIcon()) {
      this.overlayIcon();
    } else {
      RelativeContainer() {
        // 文件夹背板
        this.appIconBackplaneBuilder();

        // 图标
        this.appIconBuilder();

        // 禁用蒙层
        this.disableMaskBuilder();

        // 按压蒙层
        this.touchMaskBuilder();

        // 图标自定义蒙层
        this.customMaskBuilder();

        // 下载蒙层
        this.installImageBuilder();

        // 图标名称
        this.appNameBuilder();

        // 通知角标
        this.badgeBuilder();

        // 堆叠应用角标
        this.superPoseBadgeBuilder();

        // 多选框
        this.multiCheckboxBuilder();
      }
      .width(this.appIconConfig.iconContainerSize)
      .height(this.appIconConfig.iconContainerSize)
      .accessibilityLevel('no')
      .visibility(this.isVisible() ? Visibility.Visible : Visibility.Hidden)
      .id(this.getContainerComponentId())
      .translate({ x: this.translateX + this.iconData.transX, y: this.translateY + this.iconData.transY })
      .offset({ x: this.iconData.offsetX, y: this.iconData.offsetY })
      .foregroundEffect(this.iconData.containerForeEffectRadius < 0 ?
        null : { radius: this.iconData.containerForeEffectRadius })
      .opacity(this.iconData.containerOpacity)
      .scale({ x: this.iconData.containerScale, y: this.iconData.containerScale })
      .onTouch((event: TouchEvent) => this.iconEvent.getIconContainerEventIface()?.onTouch(event))
      .onFocus(() => {
        log.showInfo(`onFocus: ${this.iconData.iconId}`);
        this.isContainerFocus = true;
      })
      .onBlur(() => {
        log.showInfo(`onBlur: ${this.iconData.iconId}`);
        this.isContainerFocus = false;
      })
      .onClick(this.appIconConfig.enableContainerClickEvent ? this.handleContainerOnClickEvent : undefined)
      .attributeModifier(this.iconContainerModifier)
      .focusable(this.appIconConfig.enableFocus)
    }
  }
}