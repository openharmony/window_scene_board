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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  EvtBus,
  GlobalContext,
  IconResourceManager,
  HiDfxEventUtil,
  localEventManager,
  onLineThemeUtil,
  ResourceManager,
  ThemeActivationEvent
} from '@ohos/frameworkwrapper';
import { AppData, launcherStatusUtil } from '@ohos/windowscene';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import {
  AppModel,
  ReceiveEventInfo,
  StyleConstants,
  MultiSelectManager,
  ShortcutViewModel,
  EditModeConstants,
  multiSelectListenManger,
  MultiSelectListenerType,
  CheckboxParentEnum,
  MenuInfo,
  AppIconModel,
  ListenerItemType,
  GridLayoutUtil
} from '../../TsIndex';
import { EventConstants } from '../../constants/EventConstants';
import {
  ActionEffectFlag,
  AppGalleryEventInfo,
  AppStatus,
  CommonConstants,
  IconCanvasType,
} from '../../constants/CommonConstants';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { BadgeAnimationType } from '../../uicomponents/CustomBadge';
import { nameAppearAnimate } from '../../animation/LauncherAnimation';
import { appIconMsgKeyUtil } from '../common/AppIconMsgKeyUtil';
import { AppIconConfig } from '../config/AppIconConfig';
import { AppIconStyleConfig } from '../config/AppIconStyleConfig';
import { AppIconLongPressGestureEventIface } from '../interface/AppIconLongPressGestureEventIface';
import { AppIconContainerModifier } from '../interface/AppIconContainerModifier';
import { AppIconDragEventIface } from '../interface/AppIconDragEventIface';
import { AppIconInitParam } from '../interface/AppIconInitParam';
import { AppIconDefaultModifier } from '../interface/AppIconDefaultModifier';
import { AppNameEvent } from './AppNameEvent';
import { AppIconBackplaneEvent } from './AppIconBackplaneEvent';
import { AppIconDisableMaskEvent } from './AppIconDisableMaskEvent';
import { AppIconBadgeEvent } from './AppIconBadgeEvent';
import { AppIconBadgeVm } from './AppIconBadgeVm';
import { AppIconMenuVm } from './AppIconMenuVm';
import { AppIconMenuEvent } from './AppIconMenuEvent';
import { AppNameVm } from './AppNameVm';
import { AppIconBackplaneVm } from './AppIconBackplaneVm';
import { AppIconDisableMaskVm } from './AppIconDisableMaskVm';
import { AppIconData } from './AppIconData';
import { AppIconTouchEventIface } from '../interface/AppIconTouchEventIface';
import { AppIconContextMenuIface } from '../interface/AppIconContextMenuIface';
import { AppIconResIface } from '../interface/AppIconResIface';
import { AppIconTransitionController } from './AppIconTransitionController';
import { AppIconGestureJudgeIface } from '../interface/AppIconGestureJudgeIface';
import { AppIconHoverEventIface } from '../interface/AppIconHoverEventIface';
import { AppIconMouseEventIface } from '../interface/AppIconMouseEventIface';
import { AppIconBaseCanvas } from '../interface/AppIconBaseCanvas';
import { AppIconResConfig } from './AppIconResConfig';
import { AppIconTouchEvent } from './AppIconTouchEvent';
import { AppIconContainerTouchEvent } from './AppIconContainerTouchEvent';
import { AppIconHoverEvent } from './AppIconHoverEvent';
import { AppIconMouseEvent } from './AppIconMouseEvent';
import { AppIconLongPressGestureEvent } from './AppIconLongPressGestureEvent';
import { AppIconContextMenu } from './AppIconContextMenu';
import { AppIconDragEvent } from './AppIconDragEvent';
import { AppIconGestureJudgeEvent } from './AppIconGestureJudgeEvent';
import { AppIconShadowData } from '../../bean/AppIconShadowData';
import { AppIconShadowViewModel } from '../../viewmodel/AppIconShadowViewModel';
import { AppIconActiveEventIface } from '../interface/AppIconActiveEventIface';
import { AppIconDynamicShadowViewModel } from './AppIconDynamicShadowViewModel';
import { AppIconDynamicShadowData } from './AppIconDynamicShadowData';
import { AppInstallEventKey, AppInstallEventType } from '../../appinstall/AppInstallEventKey';
import { IconChangeListener } from '../../model/AppModel';
import { AppIconCheckAndFixIface } from '../interface/AppIconCheckAndFixIface';
import { AppIconCheckAndFixManager } from './AppIconCheckAndFixManager';
import { SCBConstants } from '@ohos/commonconstants';
import { IconDataDebugParam } from '../../utils/SceneMsgUtils';

const TAG = 'AppIconCommonEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);
const FORM_CREATE_SHORTCUT_HIDDEN: number = 0.005;
const FORM_CREATE_SHORTCUT_TIME: number = 500;

export class AppIconCommonEvent implements AppIconCheckAndFixIface {
  // 应用安装状态
  protected iconData: AppIconData = new AppIconData();
  private itemInfo: AppItemInfo = new AppItemInfo();
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  // 实时获取状态变量信息
  private iconSizeCb?: () => number;
  private isInDragCb?: () => boolean;
  private isShowCancelDialogCb?: (isShow: boolean) => void;
  private uiContextCb?: UIContext;
  private appIconConfig: AppIconConfig = new AppIconConfig();

  // 父组件的Modifier
  private iconContainerModifier?: AppIconContainerModifier;
  private iconModifier?: AppIconDefaultModifier;

  // 应用名称(AppName)的事件、状态变量
  private appNameVm?: AppNameVm;
  private appNameEvent?: AppNameEvent;

  // 角标的事件处理类、状态变量、Modifier
  private iconBadgeVm?: AppIconBadgeVm;
  private iconBadgeEvent?: AppIconBadgeEvent;

  // 菜单的事件处理类、状态变量、Modifier
  private iconMenuEvent?: AppIconMenuEvent;
  private iconMenuVm?: AppIconMenuVm;

  // 背板
  private iconBackplaneVm?: AppIconBackplaneVm;
  private iconBackplaneEvent?: AppIconBackplaneEvent;

  // 禁用蒙层
  private disableMaskVm?: AppIconDisableMaskVm;
  private disableMaskEvent?: AppIconDisableMaskEvent;

  // 分层图标阴影相关
  private appIconShadowData?: AppIconShadowData;
  private appIconShadowViewModel?: AppIconShadowViewModel;

  // 图标动态阴影相关
  private appIconDynamicShadowData?: AppIconDynamicShadowData;
  private appIconDynamicShadowViewModel?: AppIconDynamicShadowViewModel;

  // 图标生效事件
  private appIconActiveEvent?: AppIconActiveEventIface;

  // 编辑模式多选回调
  private multiSelectCb?: MultiSelectListenerType;
  private timeId: number = -1;

  // 图标刷新事件监听
  private listener: IconChangeListener = {
    onIconResourceChange: (): void => {
      this.onIconResourceChange();
    }
  };

  private iconContainerTouchEvent?: AppIconTouchEventIface;
  private iconTouchEvent?: AppIconTouchEventIface;
  private iconHoverEvent?: AppIconHoverEventIface;
  private iconMouseEvent?: AppIconMouseEventIface;
  private iconLongPressGestureEvent?: AppIconLongPressGestureEventIface;
  private iconLongPressContextMenu?: AppIconContextMenuIface;
  private iconRightClickContextMenu?: AppIconContextMenuIface;
  private iconDragEvent?: AppIconDragEventIface;
  private iconGestureJudgeEvent?: AppIconGestureJudgeIface;
  private iconResConfig?: AppIconResIface;
  private iconDragMaskCanvas?: AppIconBaseCanvas;
  private iconLongPressMaskCanvas?: AppIconBaseCanvas;
  private iconTouchMaskCanvas?: AppIconBaseCanvas;
  private iconPressMaskCanvas?: AppIconBaseCanvas;
  private iconDisableMaskCanvas?: AppIconBaseCanvas;
  private iconInstallMaskCanvas?: AppIconBaseCanvas;
  private iconCustomMaskCanvas?: AppIconBaseCanvas;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private iconTransitionController: AppIconTransitionController = new AppIconTransitionController();
  private eventHandleMap: Map<string, Function> = new Map();
  private formCreateShortcutTimeoutId: number = 0;

  // 应用退出返回到图标的事件回调
  private onAppIconActiveEventCb: (isBackToIcon: boolean) => void = (isBackToIcon: boolean): void => {
    isBackToIcon ? this.onActive(TAG, 'onAppIconActiveEventCb') : this.onInactive(TAG, 'onAppIconActiveEventCb');
  };

  private onAppUpdateEventCb: (data: AppGalleryEventInfo) => void = (data: AppGalleryEventInfo): void => {
    let appStatus = data.status as AppStatus;
    log.showInfo('appInstall onAppUpdateEventCb: %{public}s appStatus: %{public}d', data.bundleName, appStatus);
    if (appStatus !== undefined) {
      this.iconData.setAppStatus(appStatus);
      this.itemInfo.appStatus = appStatus;
    }
  }

  // Icon 父控件透明度变化事件
  private onContainerOpacityChangeCb: (opacity: number) => void = (opacity: number): void => {
    log.showInfo(`icon container opacity change: ${opacity}.`);
    this.iconData.containerOpacity = opacity;
  };

  // 编辑模式下拖拽，弹出删除弹窗, 此时图标组件需要隐藏
  private onRemoveDialogChangeEventCb = (isShow: boolean) => {
    if (!launcherStatusUtil.isCurrentDesktopVisible(this.appIconConfig.isOuterDesktop)) {
      log.showInfo('removeDialogChange product is small fold. screen status inconsistency');
      return;
    }

    log.showInfo(`remove dialog show: ${isShow}.`);
    this.isShowCancelDialogCb?.(isShow);
  };

  // 编辑模式点击事件透传
  private onAppItemAccessibilityClickEventCb: () => void = () => this.appItemAccessibilityClickEvent();

  // 监听事件listener
  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string[]) => {
      this.handleLocalEvent(event, params);
    }
  }

  // 初始化事件处理表
  private initEventHandleMap(): void {
    this.eventHandleMap.set(EventConstants.EVENT_REFRESH_ICON_IMAGE, this.handleRefreshIconImageEvent);
    this.eventHandleMap.set(EventConstants.EVENT_REFRESH_SHORTCUT_IMAGE, this.handleRefreshShortcutImageEvent);
    this.eventHandleMap.set(`updateIconImage_${this.itemInfo.bundleName}`, this.handleUpdateIconImageEvent);
    this.eventHandleMap.set(`createFormShortcutEvent_${this.itemInfo.bundleName}`, this.handleCreateFormShortcut);
  }

  // 主题切换事件
  private handleThemeChangeEvent = (event: ThemeActivationEvent): void => {
    log.showInfo(`ThemeActivationEvent: ${event?.target}, ${event?.themeType}`);
    this.iconData.isOnlineTheme = onLineThemeUtil.isOnlineTheme();
  }

  /**
   * 初始化AppIconCommonEvent信息
   * @param param AppIconInitParam
   */
  public init(param: AppIconInitParam): void {
    if (!param || !param.iconData || !param.iconConfig || !param.itemInfo || !param.iconSizeCb || !param.isInDragCb ||
      !param.iconModifier || !param.iconContainerModifier) {
      log.showError('init param failed!');
      return;
    }

    this.iconData = param.iconData;
    this.appIconConfig = param.iconConfig;
    this.itemInfo = param.itemInfo;
    this.iconSizeCb = param.iconSizeCb;
    this.isInDragCb = param.isInDragCb;
    this.isShowCancelDialogCb = param.isShowCancelDialogCb;
    this.uiContextCb = param.uiContextCb;
    this.iconModifier = param.iconModifier;
    this.iconContainerModifier = param.iconContainerModifier;
    if (!this.iconResConfig) {
      this.iconResConfig = new AppIconResConfig();
    }

    this.initViewModels(param);
    this.initIconEvents(param);
    this.initIconData(param.isInitIconId);
    this.initEventhubEvent();
    EvtBus.on(ThemeActivationEvent, this.handleThemeChangeEvent);
    if (!this.itemInfo.isEmergency) {
      this.initTransitionController();
    }

    this.listener.bundleName = this.itemInfo.bundleName;
    this.listener.moduleName = this.itemInfo.moduleName;
    this.listener.abilityName = this.itemInfo.abilityName;

    AppModel.getInstance().registerIconChangeListener(this.listener);
    if (this.appIconConfig.enableSupportCheckAndFix &&
      GridLayoutUtil.isAppInstalled(this.itemInfo) && this.itemInfo.typeId !== CommonConstants.TYPE_SHORTCUT_ICON) {
      // 图标检测只支持已安装的应用
      AppIconCheckAndFixManager.getInstance().registerAppIconCheckAndFix(this.itemInfo.bundleName, this);
    }
    this.initEventHandleMap();
    this.registerLocalEventListener();
    this.initMultiSelectCb();
    this.initAppNameAnimate();

    if (this.isInDragCb?.()) {
      this.onActive(TAG, 'init', 'isInDrag');
    }
  }

  /**
   * 从卡片管理添加一键锁屏快捷方式到桌面
   */
  public onCreateFormShortcutHandler(): void {
    if (this.itemInfo.typeId !== CommonConstants.TYPE_SHORTCUT_ICON ||
      this.itemInfo.bundleName !== CommonConstants.SCENEBOARD_BUNDLE) {
      return;
    }
    const createFormShortcutId: string = AppStorage.get<string>('createFormShortcutId') as string;
    log.showWarn('onCreateFormShortcutHandler %{public}s', createFormShortcutId);
    if (!CheckEmptyUtils.checkStrIsEmpty(createFormShortcutId)) {
      this.nameDelayAnimateHandler();
      this.iconData.setIconOpacity(FORM_CREATE_SHORTCUT_HIDDEN, TAG, 'shortcut');
      this.iconData.checkboxOpacity = FORM_CREATE_SHORTCUT_HIDDEN;
    } else {
      this.iconData.nameOpacity = 1;
      this.iconData.setIconOpacity(1, TAG, 'shortcut');
      this.iconData.checkboxOpacity = 1;
    }
  }

  private nameDelayAnimateHandler(): void {
    this.iconData.nameOpacity = 0;
    this.formCreateShortcutTimeoutId = setTimeout(() => {
      this.iconData.nameOpacity = 1;
      clearTimeout(this.formCreateShortcutTimeoutId);
    }, FORM_CREATE_SHORTCUT_TIME);
  }

  /**
   * 释放资源、事件句柄
   */
  public destroy(): void {
    this.iconTransitionController.unregisterController();
    this.destroyEventhubEvent();
    AppModel.getInstance().unregisterIconChangeListener(this.listener);
    localEventManager.unregisterEventListener(this.localEventListener);

    if (this.appIconConfig.enableSupportCheckAndFix &&
      GridLayoutUtil.isAppInstalled(this.itemInfo) && this.itemInfo.typeId !== CommonConstants.TYPE_SHORTCUT_ICON) {
      AppIconCheckAndFixManager.getInstance().unregisterAppIconCheckAndFix(this.itemInfo.bundleName, this);
    }

    this.destroyViewEvent();
    this.clearTimeId(this.timeId);
    multiSelectListenManger.unregister(this.multiSelectCb);
    this.multiSelectCb = undefined;
    EvtBus.off(ThemeActivationEvent, this.handleThemeChangeEvent);
    if (this.formCreateShortcutTimeoutId) {
      clearTimeout(this.formCreateShortcutTimeoutId);
      this.formCreateShortcutTimeoutId = 0;
    }
  }

  /**
   * 获取Icon 阴影配置信息, 可基于业务场景覆写
   * @returns ShadowOptions | null
   */
  public getIconShadowOptions(): ShadowOptions | null {
    return AppIconStyleConfig.getIconShadowOptions(this.appIconConfig.enableShadow);
  }

  /**
   * 应用安装状态变化的接口
   * @param status AppStatus
   */
  public onItemAppStatusChange(status: AppStatus): void {
    if (this.iconData.appStatus !== status) {
      this.itemInfo.appStatus = status;
      this.iconData.setAppStatus(status);
      log.showInfo(`onItemAppStatusChange: ${status}.`);
    }
  }

  /**
   * 控制图标显示的接口
   * @param module 模块, 一般是类TAG
   * @param caller 调用方, 精确到函数
   * @param extra 额外参数打印信息
   */
  public onActive(module: string, caller: string, extra?: string): void {
    const isIconShow: boolean = this.iconData.iconOpacity > 0;
    log.showWarn(`onActive bundleName:${this.itemInfo.bundleName}, [${module}] set icon from ` +
      `${isIconShow ? 'show' : 'hidden'} to [hidden], caller: ${caller}, extra info: ${extra}.`);
    if (this.appIconActiveEvent) {
      log.showInfo('has appIconActiveEvent');
      this.appIconActiveEvent.onActive();
      if (!this.appIconActiveEvent.useDefaultIconShow) {
        return;
      }
    }
    if (isIconShow) {
      this.iconData.setIconOpacity(0, module, caller, extra);
      this.iconBadgeEvent?.onActive(true);
    }
  }

  /**
   * 控制图标隐藏的接口
   * @param module 模块, 一般是类TAG
   * @param caller 调用方, 精确到函数
   * @param extra 额外参数打印信息
   */
  public onInactive(module: string, caller: string, extra?: string): void {
    try {
      const isIconShow: boolean = this.iconData.iconOpacity > 0;
      log.showWarn(`onInactive bundleName:${this.itemInfo.bundleName}, [${module}] set icon from ` +
        `${isIconShow ? 'show' : 'hidden'} to [show], caller: ${caller}, extra info: ${extra}.`);
      if (this.appIconActiveEvent) {
        log.showInfo('has appIconActiveEvent');
        this.appIconActiveEvent.onInactive();
        if (!this.appIconActiveEvent.useDefaultIconShow) {
          return;
        }
      }
      if (!isIconShow) {
        if (this.appIconConfig.enableName) {
          this.iconData.setIconOpacity(1, module, caller, extra);
        } else {
          // enableName为false时,长按图标再松手会概率出现图标闪烁,需要加个动效强制送显
          animateTo({ duration: 0 }, () => {
            this.iconData.setIconOpacity(1, module, caller, extra);
          });
        }
        this.iconBadgeEvent?.onActive(false);
      }
    } catch (err) {
      log.showError(`onInactive err ${err}`);
    }
  }

  /**
   * Icon父容器显隐控制接口, 创建小文件夹过程中等需要让Container隐藏的场景，可以在此处覆写
   * @returns boolean 图标外部容器是否显示
   */
  public isIconContainerShow(): boolean {
    return !this.appIconConfig.externCb?.isHideIconContainer?.();
  }

  /**
   * 获取菜单事件处理实例
   * @returns AppIconMenuEvent
   */
  public getIconMenuEvent(): AppIconMenuEvent {
    return this.iconMenuEvent as AppIconMenuEvent;
  }

  /**
   * 获取菜单vm处理实例
   * @returns AppIconMenuVm
   */
  public getIconMenuVm(): AppIconMenuVm {
    return this.iconMenuVm as AppIconMenuVm;
  }

  /**
   * IconChangeListener 的接口实现，registerIconChangeListener注册实例；
   * 监控BMS资源更新的事件
   */
  public onIconResourceChange(): void {
    log.showInfo(`onIconResourceChange, bundleName: ${this.itemInfo.bundleName}, ` +
      `isOuterDesktop: ${this.appIconConfig?.isOuterDesktop}`);
    this.iconResConfig?.initIconImage(this.itemInfo, this.iconData).then(() => {
      this.updateCanvas();
    });
  }

  private updateCanvas() {
    // 常驻不下树的canvas手动触发刷新重绘, 其他canvas(长按、拖拽)出现时上树自动重绘
    const iconSize: number = this.iconSizeCb?.() as number;
    if (this.appIconConfig.enableDisableMask && this.disableMaskVm?.visible) {
      this.iconDisableMaskCanvas?.updateMask(this.iconData.image, iconSize, this.itemInfo);
    }
    if (this.appIconConfig.enableInstallAnimate && !GridLayoutUtil.isAppInstalled(this.itemInfo)) {
      this.iconInstallMaskCanvas?.updateMask(this.iconData.image, iconSize, this.itemInfo);
    }
    if (this.iconData.isShowMask) {
      this.iconCustomMaskCanvas?.updateMask(this.iconData.image, iconSize, this.itemInfo);
    }
  }

  /**
   * 外部业务如果重定义isIconShow的条件，可以重写该函数
   * @returns boolean 图标是否显现
   */
  public isIconShow(): boolean {
    return this.iconData.iconOpacity > 0;
  }

  /**
   * 拖拽开始、通知, 状态变量消费事件
   * @param isDragStart 拖拽开始、停止标志
   * @param isInDrag 拖拽过程态标志
   */
  public onEqualToDropItemChange(isDragStart: boolean, isInDrag: boolean): void {
    log.showInfo(`onEqualToDropItemChange, isDragStart: ${isDragStart},isInDrag: ${isInDrag}.`);
    if (!this.iconBadgeVm) {
      log.showError('onEqualToDropItemChange, iconBadgeVm is invalid!');
      return;
    }

    // 落位动效过程中icon支持点击，需要使用透明度控制显隐
    if (isInDrag) {
      this.onActive(TAG, 'onEqualToDropItemChange', 'isInDrag');
      this.iconBadgeVm.animate = BadgeAnimationType.DEFAULT;
    } else {
      this.onInactive(TAG, 'onEqualToDropItemChange', '!isInDrag');
      this.iconBadgeVm.animate = BadgeAnimationType.DRAG_DROP;
    }
  }

  /**
   * isInDrag, 状态变量消费事件
   * @param isDragStart 拖拽开始、停止标志
   * @param isInDrag 拖拽过程态标志
   */
  public isEqualToDragItemChange(isDragStart: boolean, isInDrag: boolean): void {
    log.showInfo(`isEqualToDragItemChange, isDragStart: ${isDragStart}, isInDrag: ${isInDrag}.`);
    if (!isDragStart && !DeviceHelper.isPC()) {
      if (MultiSelectManager.getInstance().isInMultiSelect) {
        this.appNameVm?.modifier.attribute?.opacity(0);
        this.appNameEvent?.changeAppNameOpacity(1);
      } else {
        this.appNameVm?.modifier.attribute?.opacity(0);
        nameAppearAnimate(() => {
          this.appNameVm?.modifier.attribute?.opacity(1);
        });
      }
    }
  }

  /**
   * 获取CheckboxParentEnum类型
   * @returns CheckboxParentEnum
   */
  public getMultiSelectIconType(): CheckboxParentEnum {
    if (this.appIconConfig.appDataOfTransitionController?.isOpenFolder) {
      return CheckboxParentEnum.AppInFolder;
    } else {
      return CheckboxParentEnum.App;
    }
  }

  /**
   * 显示图像加载错误信息
   * @param error
   */
  public showImageErrorMessage(error: ImageError): void {
    log.showError(`get image error: ${error?.message}, bunldName: ${this.itemInfo.bundleName}, ` +
      `isOuterDesktop: ${this.appIconConfig?.isOuterDesktop}!`);
    this.iconResConfig?.reInitIconImage?.(this.itemInfo, this.iconData).then(() => {
      this.updateCanvas();
    });
  }

  private registerLocalEventListener(): void {
    const events: string[] = [
      EventConstants.EVENT_REFRESH_ICON_IMAGE,
      EventConstants.EVENT_REFRESH_SHORTCUT_IMAGE,
      `updateIconImage_${this.itemInfo.bundleName}`,
      `createFormShortcutEvent_${this.itemInfo.bundleName}`,
    ];
    localEventManager.registerEventListener(this.localEventListener, events);
  }

  private handleLocalEvent(event: string, params: string[]): void {
    if (this.eventHandleMap.has(event)) {
      try {
        this.eventHandleMap.get(event)?.(this, params);
      } catch (error) {
        log.showError(`handleLocalEvent error ${error?.code}, ${error?.message}`);
      }
    }
  }

  /**
   * 开机校验场景
   * @param params string[] 消息携带的入参
   */
  private handleRefreshIconImageEvent(thisEvent: AppIconCommonEvent, params: string[]): void {
    if (!thisEvent || CheckEmptyUtils.isEmptyArr(params)) {
      return;
    }

    let index: number = params.findIndex((bundleName: string) => {
      return bundleName === thisEvent.itemInfo.bundleName;
    });

    if (index >= 0) {
      thisEvent.updateShortcutIconId();
      log.showInfo(`handleRefreshIconImageEvent, bundleName: ${thisEvent.itemInfo.bundleName}, ` +
        `isOuterDesktop: ${thisEvent.appIconConfig?.isOuterDesktop}`);
      thisEvent.iconResConfig?.initIconImage(thisEvent.itemInfo, thisEvent.iconData).then(() => {
        thisEvent.updateCanvas();
      });
    }
  }

  /**
   * 版本校验完成 快捷图标刷新
   * @param params 消息携带的入参
   */
  private handleRefreshShortcutImageEvent(thisEvent: AppIconCommonEvent, params: string[]): void {
    if (!thisEvent || thisEvent.itemInfo.typeId !== CommonConstants.TYPE_SHORTCUT_ICON) {
      return;
    }

    log.showInfo(`shortcutRefresh typeId: ${thisEvent.itemInfo.typeId}, bundleName: ${thisEvent.itemInfo.bundleName},` +
      ` shortcutId: ${thisEvent.itemInfo.shortcutId}, appIndex: ${thisEvent.itemInfo.appIndex},` +
      ` isOuterDesktop: ${thisEvent.appIconConfig?.isOuterDesktop}`);
    thisEvent.iconResConfig?.initIconImage(thisEvent.itemInfo, thisEvent.iconData).then(() => {
      thisEvent.updateCanvas();
    });
  }

  /**
   * EVENT_DYNAMIC_ICON_CHANGED, 图标资源重新刷新
   * @param params string[] 消息携带的入参
   */
  private handleUpdateIconImageEvent(thisEvent: AppIconCommonEvent, params: string[]): void {
    if (!thisEvent) {
      return;
    }
    thisEvent.updateShortcutIconId();
    log.showInfo(`handleUpdateIconImage, bundleName: ${thisEvent.itemInfo.bundleName}, appIndex: ${thisEvent.itemInfo.appIndex}` +
      `isOuterDesktop: ${thisEvent.appIconConfig?.isOuterDesktop}`);
    thisEvent.iconResConfig?.initIconImage(thisEvent.itemInfo, thisEvent.iconData).then(() => {
      thisEvent.updateCanvas();
    });
  }

  /**
   * EVENT_CREATE_FORM_SHORTCUT, // 从卡片管理添加快捷方式到桌面
   * @param params string[] 消息携带的入参
   */
  private handleCreateFormShortcut(thisEvent: AppIconCommonEvent, params: string[]): void {
    if (!thisEvent) {
      return;
    }
    thisEvent.onCreateFormShortcutHandler();
  }

  private destroyEventhubEvent(): void {
    if (!this.desktopContext) {
      return;
    }

    if (this.appIconConfig.enableContainerOpacityChange) {
      let iconContainerOpacityKey: string =
        appIconMsgKeyUtil.getIconContainerOpacityKey(this.itemInfo, this.appIconConfig.appDataOfTransitionController);
      log.showInfo(`destroyEventhubEvent, iconContainerOpacityKey is ${iconContainerOpacityKey}`);
      this.desktopContext.eventHub.off(iconContainerOpacityKey, this.onContainerOpacityChangeCb);
    }

    this.desktopContext.eventHub.off(appIconMsgKeyUtil.getIconAnimBackToIconKey(this.itemInfo,
      this.appIconConfig.appDataOfTransitionController), this.onAppIconActiveEventCb);

    this.desktopContext.eventHub.off(appIconMsgKeyUtil.getItemAccessibilityClickKey(this.itemInfo),
      this.onAppItemAccessibilityClickEventCb);

    this.desktopContext.eventHub.off(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE + this.itemInfo.keyName,
      this.onRemoveDialogChangeEventCb);
    let appUpdateKey =
      AppInstallEventKey.getStatusChangeEventKey(this.itemInfo.bundleName, AppInstallEventType.UPDATE_ICON);
    this.desktopContext.eventHub.off(appUpdateKey, this.onAppUpdateEventCb);
    this.desktopContext.eventHub.off(SCBConstants.ICON_DATA_DEBUG, this.updateIconDataForDebug);
  }

  /**
   *  解除视图事件初始化时的注册
   */
  private destroyViewEvent(): void {
    this.iconMenuEvent?.destroy();
    this.iconBadgeEvent?.destroy();
    this.iconBackplaneEvent?.destroy();
    this.disableMaskEvent?.destroy();
  }

  private initTransitionController(): void {
    const appData: AppData =
      this.appIconConfig.appDataOfTransitionController?.setAppIconId(this.iconData.iconId) as AppData;

    this.iconTransitionController.registerController(appData,
      (module: string, caller: string, extra?: string) => this.onActive(module, caller, extra),
      (module: string, caller: string, extra?: string) => this.onInactive(module, caller, extra));
  }

  private initIconData(isInitIconId: boolean): void {
    if (isInitIconId) {
      this.iconData.iconId = AppIconModel.getInstance().getIconId(this.itemInfo,
        this.appIconConfig.appDataOfTransitionController?.extraId, this.appIconConfig.isOuterDesktop,
        this.appIconConfig?.isOpenFolder);
    }
    log.showInfo(`initIconData, bundleName: ${this.itemInfo.bundleName}, ` +
      `isOuterDesktop: ${this.appIconConfig?.isOuterDesktop}`);
    this.iconData.appStatus = this.itemInfo.appStatus as AppStatus;
    if (this.itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON && this.itemInfo.appStatus === AppStatus.PENDING) {
      this.iconData.isShowMask = true;
      this.iconData.maskBgColor = StyleConstants.APP_ICON_INSTALL_COLOR;
      this.iconData.maskOpacity = 1;
    }
    this.iconResConfig?.initIconImage(this.itemInfo, this.iconData);
  }

  private isEnableEffect(effect: number): boolean {
    return (this.appIconConfig.enableEffectFlag & effect) !== 0;
  }

  private initEventhubEvent(): void {
    if (CheckEmptyUtils.checkStrIsEmpty(this.itemInfo.keyName)) {
      log.showError('init event hub failed, keyName is invalid!');
      return;
    }

    if (!this.desktopContext) {
      return;
    }

    this.desktopContext.eventHub.on(appIconMsgKeyUtil.getItemAccessibilityClickKey(this.itemInfo),
      this.onAppItemAccessibilityClickEventCb);

    if (!this.isEnableEffect(ActionEffectFlag.EFFECT_SHOW)) {
      log.showWarn('no support the show effect!');
      return;
    }

    this.desktopContext.eventHub.on(EditModeConstants.EVENT_EDIT_MODE_DROP_TO_DELETE + this.itemInfo.keyName,
      this.onRemoveDialogChangeEventCb);

    if (this.appIconConfig.enableContainerOpacityChange) {
      let iconContainerOpacityKey: string =
        appIconMsgKeyUtil.getIconContainerOpacityKey(this.itemInfo, this.appIconConfig.appDataOfTransitionController);
      log.showInfo(`initEventhubEvent, iconContainerOpacityKey is ${iconContainerOpacityKey}`);
      this.desktopContext.eventHub.on(iconContainerOpacityKey, this.onContainerOpacityChangeCb);
    }

    this.desktopContext.eventHub.on(appIconMsgKeyUtil.getIconAnimBackToIconKey(this.itemInfo,
      this.appIconConfig.appDataOfTransitionController), this.onAppIconActiveEventCb);

    if (this.itemInfo.appIndex === CommonConstants.MAIN_APP_INDEX) {
      log.showInfo('appInstall getAppUpdateEventId: %{public}s appStatus: %{public}d',
        this.itemInfo.keyName ?? this.itemInfo.bundleName, this.itemInfo.appStatus);
      this.desktopContext.eventHub.on(AppInstallEventKey.getStatusChangeEventKey(this.itemInfo.bundleName,
        AppInstallEventType.UPDATE_ICON), this.onAppUpdateEventCb);
    }
    this.desktopContext.eventHub.on(SCBConstants.ICON_DATA_DEBUG, this.updateIconDataForDebug);
  }

  private updateIconDataForDebug: (bundleName: string, iconDataProperty: string, value: string) => void =
    (bundleName: string, iconDataProperty: string, value: string): void => {
      if (bundleName !== this.itemInfo.bundleName) {
        log.showWarn(`updateIconDataForDebug bundleName:${bundleName} is not current bundleName:${this.itemInfo.bundleName}`);
        return;
      }
      if (iconDataProperty === IconDataDebugParam.ICON_OPACITY) {
        this.iconData.iconOpacity = Number.parseInt(value);
      }
      if (iconDataProperty === IconDataDebugParam.CONTAINER_OPACITY) {
        this.iconData.containerOpacity = Number.parseInt(value);
      }
      if (iconDataProperty === IconDataDebugParam.ICON_ID) {
        this.iconData.iconId = value;
      }
      log.showInfo(`updateIconDataForDebug finished and bundleName:${bundleName} iconDataProperty:${iconDataProperty} value:${value}`);
    };

  private updateShortcutIconId(): void {
    let iconId = ShortcutViewModel.getInstance().getShortcutIconId(this.itemInfo);
    if (iconId) {
      this.itemInfo.appIconId = iconId;
    }
  }

  private appItemAccessibilityClickEvent(): void {
    log.showInfo(`DesktopAccessibility appItemAccessibilityClickEventitem:${this.itemInfo?.keyName}, ` +
      `appName:${this.itemInfo?.appName}.`);
    if (!launcherStatusUtil.isCurrentDesktopVisible(this.appIconConfig.isOuterDesktop)) {
      log.showInfo('appItemAccessibilityClickEvent product is small fold. screen status inconsistency');
      return;
    }
    this.getIconTouchEventIface()?.onClick();
  }

  private initViewModels(param: AppIconInitParam): void {
    if (this.appIconConfig.enableName) {
      this.appNameVm = param.appNameVm;
      this.appNameEvent = new AppNameEvent(this.appNameVm);
      this.appNameVm.modifier.enableWallpaperFontColor = this.appIconConfig.enableWallpaperFontColor;
    }

    if (this.appIconConfig.enableMenu && param.iconMenuVm) {
      this.iconMenuVm = param.iconMenuVm;
      this.iconMenuEvent = new AppIconMenuEvent(this.iconMenuVm);
      this.iconMenuEvent.init(this.itemInfo,
        (iconVisible: boolean, isLongPressShow: boolean): void => {
          if (isLongPressShow && !this.isInDragCb?.() && this.appIconConfig.enableLongPressIconVisibility) {
            log.showInfo(`iconVisible: ${iconVisible}.`);
            if (iconVisible) {
              this.onInactive(TAG, 'initViewModels', 'iconMenuEvent Visible');
            } else {
              this.onActive(TAG, 'initViewModels', 'iconMenuEvent Hidden');
            }
          }
          if (this.appIconConfig.enableName && this.appIconConfig.enableNameAnim) {
            this.appNameEvent?.changeAppNameOpacity(iconVisible ? 1 : 0);
          }
        }, this.appIconConfig.externCb?.onMenuDisappear, this.appIconConfig.externCb?.onMenuAppear);
    }

    if (this.appIconConfig.enableBadge && param.iconBadgeVm) {
      this.iconBadgeVm = param.iconBadgeVm;
      this.iconBadgeEvent = new AppIconBadgeEvent(this.iconBadgeVm);
      this.iconBadgeEvent.init(this.itemInfo);
    }

    if (this.appIconConfig.enableBackplane && param.backplaneVm) {
      this.iconBackplaneVm = param.backplaneVm;
      this.iconBackplaneEvent = new AppIconBackplaneEvent(this.iconBackplaneVm);
      this.iconBackplaneEvent.init(this.itemInfo.keyName as string, (isAppBackplaneOpen: boolean) => {
        this.appNameEvent?.appNameDisappearAnimate(isAppBackplaneOpen);
      });
    }

    if (this.appIconConfig.enableDisableMask && param.disableMaskVm) {
      this.disableMaskVm = param.disableMaskVm;
      this.disableMaskEvent = new AppIconDisableMaskEvent(this.disableMaskVm);
      this.disableMaskEvent.init(this.itemInfo, this.appIconConfig.externCb?.isDisableMask);
    }

    if (this.appIconConfig.enableDynamicIconShadow && param.appIconDynamicShadowData) {
      if (param.appIconShadowData) {
        this.appIconShadowData = param.appIconShadowData;
        this.appIconShadowViewModel = new AppIconShadowViewModel(this.appIconShadowData);
      }
      this.appIconDynamicShadowData = param.appIconDynamicShadowData;
      this.appIconDynamicShadowViewModel = new AppIconDynamicShadowViewModel(this.appIconDynamicShadowData);
      this.appIconDynamicShadowViewModel.init();
    }
  }

  private clearTimeId(timeId: number): void {
    if (timeId >= 0) {
      clearTimeout(timeId);
    }
  }

  private initIconEvents(param: AppIconInitParam): void {
    this.initIconContainerTouchEvent(param);
    this.initIconHoverEvent();
    this.initIconMouseEvent(param);
    this.initIconLongPressContextMenu(param);
    this.initIconLongPressGestureEvent(param);
    this.initIconTouchEvent(param);
    this.initIconRightClickContextMenu(param);
    this.initIconDragEvent(param);
    this.initIconGestureJudgeEvent(param);
  }

  private initIconTouchEvent(param: AppIconInitParam): void {
    if (this.iconTouchEvent) {
      return;
    }

    this.iconTouchEvent = new AppIconTouchEvent().initEventParam({
      itemInfo: param.itemInfo,
      iconData: param.iconData,
      appIconConfig: param.iconConfig,
      touchDownCb: (event: TouchEvent) => {
        if (param.iconConfig?.externCb?.setMenuPosition) {
          log.showInfo(`use externCb setMenuPosition, bundleName: ${param.itemInfo.bundleName}`);
          param.iconConfig?.externCb?.setMenuPosition(event, param.iconData.iconId);
          return;
        }
      },
      iconScaleCb: (scale: number) => {
        this.iconBadgeEvent?.onIconScale(scale, this.iconSizeCb?.() ?? 0);
      },
      iconSizeCb: param.iconSizeCb,
      iconLongPressAnimation: (isZoomOut: boolean) => {
        this.iconLongPressGestureEvent?.onIconLongPressZoomAnimation(isZoomOut,
          param?.itemInfo?.bundleName ?? 'unknown bundleName');
      }
    });
  }

  private initIconContainerTouchEvent(param: AppIconInitParam): void {
    if (this.iconContainerTouchEvent) {
      return;
    }

    this.iconContainerTouchEvent =
      new AppIconContainerTouchEvent().initContainerTouchParam({ itemInfo: param.itemInfo, iconData: param.iconData });
  }

  private initIconHoverEvent(): void {
    if (!this.appIconConfig.enableHoverAnimation) {
      this.iconHoverEvent = undefined;
      return;
    }

    if (this.iconHoverEvent) {
      return;
    }

    this.iconHoverEvent = new AppIconHoverEvent();
  }

  private initIconMouseEvent(param: AppIconInitParam): void {
    if (this.iconMouseEvent) {
      return;
    }

    this.iconMouseEvent = new AppIconMouseEvent().initEventParam({
      itemInfo: param.itemInfo,
      iconData: param.iconData,
      iconMenuEvent: this.iconMenuEvent as AppIconMenuEvent,
      appIconConfig: param.iconConfig,
    });
  }

  private initIconLongPressGestureEvent(param: AppIconInitParam): void {
    if (this.iconLongPressGestureEvent) {
      return;
    }
    this.iconLongPressGestureEvent = new AppIconLongPressGestureEvent().initLongPressEventParam({
      itemInfo: param.itemInfo,
      iconData: param.iconData,
      appIconConfig: param.iconConfig,
      iconBadgeVm: param.iconBadgeVm,
      iconMenuVm: param.iconMenuVm,
      iconBadgeEvent: this.iconBadgeEvent as AppIconBadgeEvent,
      iconSizeCb: this.iconSizeCb,
      // 优先使用业务侧配置的
      iconDragBuilder: param.iconConfig?.externCb?.getDragIconBuilder?.() ?? param.dragIconBuilder as CustomBuilder,
      showLongPressContextMenu: (): boolean => {
        if (!this.iconLongPressContextMenu) {
          return false;
        }
        return this.iconLongPressContextMenu.showContextMenu();
      },
      iconMenuEvent: this.iconMenuEvent as AppIconMenuEvent
    });
  }

  private initIconLongPressContextMenu(param: AppIconInitParam): void {
    if (this.iconLongPressContextMenu) {
      return;
    }

    this.iconLongPressContextMenu = new AppIconContextMenu().initContextMenuParam({
      appIconConfig: param.iconConfig,
      iconMenuVm: param.iconMenuVm,
      iconBadgeVm: param.iconBadgeVm,
      contentBuilder: param.longPressMenuBuilder,
      longPressImageBuilder: param.longPressImageBuilder,
      isLongPressMenu: true
    });
  }

  private initIconRightClickContextMenu(param: AppIconInitParam): void {
    if (this.iconRightClickContextMenu) {
      return;
    }

    this.iconRightClickContextMenu = new AppIconContextMenu().initContextMenuParam({
      appIconConfig: param.iconConfig,
      iconMenuVm: param.iconMenuVm,
      iconBadgeVm: param.iconBadgeVm,
      contentBuilder: param.rightClickMenuBuilder,
      longPressImageBuilder: param.longPressImageBuilder,
      isLongPressMenu: false
    });
  }

  private initIconDragEvent(param: AppIconInitParam): void {
    if (this.iconDragEvent) {
      return;
    }

    this.iconDragEvent = new AppIconDragEvent().initDragParam({
      itemInfo: param.itemInfo,
      iconData: param.iconData,
      appIconConfig: param.iconConfig,
      iconMenuVm: param.iconMenuVm,
      iconSizeCb: () => param?.iconSizeCb?.() ?? 0,
      iconBadgeVm: param.iconBadgeVm,
      iconBadgeEvent: this.iconBadgeEvent as AppIconBadgeEvent,
      dragIconBuilder: param.dragIconBuilder
    });
  }

  protected initIconGestureJudgeEvent(param: AppIconInitParam): void {
    if (this.iconGestureJudgeEvent) {
      return;
    }

    this.iconGestureJudgeEvent = new AppIconGestureJudgeEvent().initGestureJudgeParam({
      itemInfo: param.itemInfo,
      iconData: param.iconData,
      enableMultiSelect: param.iconConfig?.enableMultiSelect,
    });
  }

  /**
   * 更新TransitionController中的圆角
   * @param iconRadius 待更新的图标圆角
   */
  public updateRadiusOfTransCtrl(iconRadius: number): void {
    this.iconTransitionController.updateIconRadius(iconRadius);
  }

  public setIconTouchEventIface(appIconTouchEventIface: AppIconTouchEventIface): void {
    this.iconTouchEvent = appIconTouchEventIface;
  }

  public getIconTouchEventIface(): AppIconTouchEventIface | undefined {
    return this.iconTouchEvent;
  }

  public setIconContainerEventIface(appIconTouchEventIface: AppIconTouchEventIface): void {
    this.iconContainerTouchEvent = appIconTouchEventIface;
  }

  public getIconContainerEventIface(): AppIconTouchEventIface | undefined {
    return this.iconContainerTouchEvent;
  }

  public setIconHoverEventIface(appIconHoverEventIface: AppIconHoverEventIface): void {
    this.iconHoverEvent = appIconHoverEventIface;
  }

  public getIconHoverEventIface(): AppIconHoverEventIface | undefined {
    return this.iconHoverEvent;
  }

  public setIconMouseEventIface(appIconMouseEventIface: AppIconMouseEventIface): void {
    this.iconMouseEvent = appIconMouseEventIface;
  }

  public getIconMouseEventIface(): AppIconMouseEventIface | undefined {
    return this.iconMouseEvent;
  }

  public setLongPressGestureEventIface(appIconLongPressGestureEventIface: AppIconLongPressGestureEventIface): void {
    this.iconLongPressGestureEvent = appIconLongPressGestureEventIface;
  }

  public getLongPressGestureEventIface(): AppIconLongPressGestureEventIface | undefined {
    return this.iconLongPressGestureEvent;
  }

  public setIconLongPressContextMenuIface(appIconContextMenuIface: AppIconContextMenuIface): void {
    this.iconLongPressContextMenu = appIconContextMenuIface;
  }

  public getIconLongPressContextMenuIface(): AppIconContextMenuIface | undefined {
    return this.iconLongPressContextMenu;
  }

  public setIconRightClickContextMenuIface(appIconContextMenuIface: AppIconContextMenuIface): void {
    this.iconRightClickContextMenu = appIconContextMenuIface;
  }

  public getIconRightClickContextMenuIface(): AppIconContextMenuIface | undefined {
    return this.iconRightClickContextMenu;
  }

  public setIconDragEventIface(appIconDragEventIface: AppIconDragEventIface): void {
    this.iconDragEvent = appIconDragEventIface;
  }

  public getIconDragEventIface(): AppIconDragEventIface | undefined {
    return this.iconDragEvent;
  }

  public setIconGestureJudgeIface(appIconGestureJudgeIface: AppIconGestureJudgeIface): void {
    this.iconGestureJudgeEvent = appIconGestureJudgeIface;
  }

  public getIconGestureJudgeIface(): AppIconGestureJudgeIface | undefined {
    return this.iconGestureJudgeEvent;
  }

  public getIconShadowViewModel(): AppIconShadowViewModel | undefined {
    return this.appIconShadowViewModel;
  }

  public getIconResIface(): AppIconResIface {
    return this.iconResConfig as AppIconResIface;
  }

  public setIconResIface(iconResConfig: AppIconResIface): void {
    this.iconResConfig = iconResConfig;
  }

  public setIconActiveEvent(iconActiveEvent: AppIconActiveEventIface): void {
    this.appIconActiveEvent = iconActiveEvent;
  }

  public getIconMaskCanvas(iconCanvasType: IconCanvasType): AppIconBaseCanvas | undefined {
    switch (iconCanvasType) {
      case IconCanvasType.TOUCH_MASK:
        if (!this.iconTouchMaskCanvas) {
          this.iconTouchMaskCanvas = new AppIconBaseCanvas(this.settings, `${this.iconData.iconId}_TouchMask_Canvas`,
            StyleConstants.APP_ICON_MASK_COLOR);
        }
        return this.iconTouchMaskCanvas as AppIconBaseCanvas;
      case IconCanvasType.PRESS_MASK:
        if (!this.iconPressMaskCanvas) {
          this.iconPressMaskCanvas = new AppIconBaseCanvas(this.settings, `${this.iconData.iconId}_PressMask_Canvas`,
            StyleConstants.APP_ICON_MASK_COLOR);
        }
        return this.iconPressMaskCanvas as AppIconBaseCanvas;
      case IconCanvasType.DISABLE_MASK:
        if (!this.iconDisableMaskCanvas) {
          this.iconDisableMaskCanvas = new AppIconBaseCanvas(this.settings, `${this.iconData.iconId}_DisableMask_Canvas`,
            StyleConstants.APP_ICON_GRAY_COLOR);
        }
        return this.iconDisableMaskCanvas as AppIconBaseCanvas;
      case IconCanvasType.DRAG_MASK:
        if (!this.iconDragMaskCanvas) {
          this.iconDragMaskCanvas = new AppIconBaseCanvas(this.settings, `${this.iconData.iconId}_DragMask_Canvas`,
            StyleConstants.APP_ICON_GRAY_COLOR);
        }
        return this.iconDragMaskCanvas as AppIconBaseCanvas;
      case IconCanvasType.LONG_PRESS_MASK:
        if (!this.iconLongPressMaskCanvas) {
          this.iconLongPressMaskCanvas = new AppIconBaseCanvas(this.settings, `${this.iconData.iconId}_LongPressMask_Canvas`,
            StyleConstants.APP_ICON_GRAY_COLOR);
        }
        return this.iconLongPressMaskCanvas as AppIconBaseCanvas;
      case IconCanvasType.INSTALL_MASK:
        if (!this.iconInstallMaskCanvas) {
          this.iconInstallMaskCanvas = new AppIconBaseCanvas(this.settings, `${this.iconData.iconId}_InstallMask_Canvas`,
            StyleConstants.APP_ICON_MASK_COLOR);
        }
        return this.iconInstallMaskCanvas as AppIconBaseCanvas;
      case IconCanvasType.CUSTOM_MASK:
        if (!this.iconCustomMaskCanvas) {
          this.iconCustomMaskCanvas = new AppIconBaseCanvas(this.settings, `${this.iconData.iconId}_CustomMask_Canvas`,
            StyleConstants.APP_ICON_MASK_COLOR);
        }
        return this.iconCustomMaskCanvas as AppIconBaseCanvas;
      default:
        log.showError(`unsupported iconCanvasType ${iconCanvasType}`);
        return undefined;
    }
  }

  public releaseIconCanvas(iconCanvasType: IconCanvasType): void {
    switch (iconCanvasType) {
      case IconCanvasType.TOUCH_MASK:
        this.iconTouchMaskCanvas = undefined;
        break;
      case IconCanvasType.PRESS_MASK:
        this.iconPressMaskCanvas = undefined;
        break;
      case IconCanvasType.DISABLE_MASK:
        this.iconDisableMaskCanvas = undefined;
        break;
      case IconCanvasType.DRAG_MASK:
        this.iconDragMaskCanvas = undefined;
        break;
      case IconCanvasType.LONG_PRESS_MASK:
        this.iconLongPressMaskCanvas = undefined;
        break;
      case IconCanvasType.INSTALL_MASK:
        this.iconInstallMaskCanvas = undefined;
        break;
      case IconCanvasType.CUSTOM_MASK:
        this.iconCustomMaskCanvas = undefined;
        break;
      default:
        break;
    }
  }

  public getIconDynamicShadowEvent(): AppIconDynamicShadowViewModel {
    return this.appIconDynamicShadowViewModel as AppIconDynamicShadowViewModel;
  }

  private initMultiSelectCb(): void {
    if (!this.appIconConfig.enableMultiSelect) {
      return;
    }

    this.multiSelectCb = {
      id: multiSelectListenManger.getListenerId(ListenerItemType.APP_ICON,
        MultiSelectManager.getInstance().getUniqueId(this.itemInfo), this.appIconConfig.isOuterDesktop),
      onLongPress: (): void => {
        log.showInfo(`receive appIcon longPress ${this.itemInfo.bundleName}.`);
        this.appNameEvent?.appNameDisappearAnimate(true);
      },
      onShowAppName: (): void => {
        log.showInfo(`receive appIcon showAppName ${this.itemInfo.bundleName}.`);
        this.appNameEvent?.appNameDisappearAnimate(false);
      }
    };

    multiSelectListenManger.register(this.multiSelectCb);
  }

  private initAppNameAnimate(): void {
    // PC不支持转场动效，此处enableAppNameTransactionAnimate配置为false
    if (this.appIconConfig.enableAppNameTransactionAnimate && this.isInDragCb?.() && this.appNameVm) {
      this.appNameVm.modifier.onInit = (instance: CommonAttribute) => {
        instance.opacity(0);
      };

      this.clearTimeId(this.timeId);
      this.timeId = setTimeout(() => {
        nameAppearAnimate(() => this.appNameVm?.modifier.attribute?.opacity(1));
      }, CommonConstants.APP_NAME_APPEAR_DELAY);
    }
  }

  /**
   * 是否支持图标检测与修复
   *
   * @returns true 支持检测&修复; false 不支持检测&修复
   */
  public isSupportCheckAndFix(): boolean {
    return this.appIconConfig?.enableSupportCheckAndFix;
  }

  /**
   * 图标检测与修复接口获取当前图标信息
   *
   * @returns 图标信息
   */
  public getCheckItemInfo(): AppItemInfo {
    return this.itemInfo;
  }

  /**
   * 当前图标的Image图片是否正常
   *
   * @returns true 图片正常; false 图片异常
   */
  public isValidImage(): boolean {
    return !CheckEmptyUtils.isEmptyStringOrPixelMap(this.iconData.image);
  }

  /**
   * 当前图标的不透明度是否正常
   *
   * @returns true 不透明度正常; false 不透明度异常
   */
  public isValidOpacity(): boolean {
    return this.iconData.iconOpacity > 0 && this.iconData.containerOpacity > 0;
  }

  /**
   * 修复图标的Image
   */
  public async fixIconImage(): Promise<void> {
    log.showInfo(`fix icon image bundleName: ${this.itemInfo.bundleName}, appIndex: ${this.itemInfo.appIndex ?? 0}`);
    // 动态时钟图标暂不支持修复，从底层资源读取，历史上未有时钟资源丢失的问题
    await IconResourceManager.getInstance().deleteIconResource(this.itemInfo.bundleName);
    this.iconResConfig?.initIconImage(this.itemInfo, this.iconData).then(() => {
      this.updateCanvas();
    });
  }

  /**
   * 修复图标的不透明度
   */
  public fixIconOpacity(): void {
    log.showInfo(`fix icon opacity bundleName: ${this.itemInfo.bundleName}, appIndex: ${this.itemInfo.appIndex ?? 0}`);
    let isIconShow: boolean = this.iconData.iconOpacity > 0;
    if (!isIconShow) {
      this.iconData.setIconOpacity(1, TAG, 'fixIconOpacity');
      this.iconBadgeEvent?.onActive(false);
    }
    let isIconContainerShow: boolean = this.iconData.containerOpacity > 0;
    if (!isIconContainerShow) {
      this.iconData.containerOpacity = 1;
    }
  }
}