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

import Curves from '@ohos.curves'
import sceneSessionManager from '@ohos.sceneSessionManager'
import { CommonUtils, Log, } from '@ohos/basicutils';
import {
  PluginInfo,
  PluginAccessInfo,
  PluginSlot,
  ViewType,
  WallpaperType,
  HiSysEventUtil,
  viewMgrPolicy,
  EventManager,
  EvtBus,
  AccessPanelHeightChangeEvent,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import {
  SCBPropertyChangeReason, SCBRotateChangeReason,
  SCBScreenProperty, SCBScreenSessionManager, SystemBarType, windowMgr, DisplayMgr} from '@ohos/windowscene';
import { SCBSystemScene, SystemSceneBuilderParam, } from '@ohos/windowscene/Index';
import { WindowConstants, SceneConstants } from '@ohos/commonconstants';
import { PluginComponentMgr, StatusBarAnimConstants } from '@ohos/systemuicommon';
import { SCBScreenSession } from '@ohos/windowscene';
import { SCBBatteryPanel } from '../batterypanel/pages/SCBBatteryPanel';
import { SCBInputMethodSubtypePanel } from '../inputmethodpanel/pages/SCBInputMethodSubTypePanel';
import { SCBInputMethodPanel } from '../inputmethodpanel/pages/SCBInputMethodPanel';
import { SCBSoundPanel } from '../soundpanel/pages/SCBSoundPanel';
import { SCBSystemPanel } from '../systempanel/pages/SCBSystemPanel';
import { SCBControlPanel } from '../controlpanel/SCBControlPanel'
import { AbilityRootComponent } from '../../pluginPanel/pages/AbilityRootComponent';
import { DynamicPluginRootComponent } from '../../pluginPanel/pages/DynamicPluginRootComponent';
import { DynamicPluginAccessComponent } from '../../pluginPanel/pages/DynamicPluginAccessComponent';
import { SCBDefaultZIndex } from '../scenemanager/SCBScreen';
import { SCBCameraPanel } from '../pccamerapanel/pages/SCBCameraPanel';
import { SCBEnterpriseSpacePanel } from '../enterprisepanel/pages/SCBEnterpriseSpacePanel';
import { USBPanel } from '../enterprisepanel/pages/USBPanel';
import { styleMgr } from '@ohos/systemuicommon';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';
import { StatusBarPanelManager } from '../../common/manager/StatusBarPanelManager';
import { SCBGestureBar } from './SCBGestureBar';
import {
  StatusBarEventId,
  StatusBarEventManager } from '@ohos/statusbarcomponent/src/main/ets/pc/manager/StatusBarEventManager';
import { PanelChangeEvent } from '@ohos/statusbarcomponent/src/main/ets/pc/utils/events';
import { SCBSystemSceneLayout } from './SCBSceneLayout';
import { SCBAssemblyPanel } from '../notificationpanel/SCBAssemblyPanel';
import mSystemPanelModel, { CONFIRM_LOGOUT_DIALOG_KEY } from '../systempanel/model/SystemPanelModel';
import { PrivacyPluginRootComponent } from '../../pluginPanel/pages/PrivacyPluginRootComponent';
import { power } from '@kit.BasicServicesKit';
import { MenuType } from '../systempanel/common/Constants';
import { SCBMicrophonePanel } from '../microphonepanel/pages/SCBMicrophonePanel';
import { SCBSuperPrivacyPanel } from '../superprivacypanel/pages/SCBSuperPrivacyPanel';
import { SCBDialogView } from '../userspanel/component/LogoutConfirmDialog/SCBDialogView';
import { Constants } from '../userspanel/common/Constants';
import { WallpaperModel } from '@ohos/wallpapercomponent/src/main/ets/wallpaper/model/WallpaperModel';
import {
  PluginWindowManager
} from '@ohos/statusbarcomponent/src/main/ets/pc/pluginwindow/PluginWindowManager';
import { SCBTrayPanel } from '../traypanel/pages/SCBTrayPanel';
import { PcModePluginRootComponent } from '../../pluginPanel/pages/PcModePluginRootComponent';
import { ControlCenterPcModePluginPanelMgr } from '../controlpanel/pcMode/ControlCenterPcModePluginPanelMgr';
import SCBMediaPlayPanel from '../controlpanel/pcMode/SCBMediaPlayPanel';
import { ModeChangeUtils } from '@ohos/frameworkwrapper/src/main/ets/utils/ModeChangeUtils';
import { SCBControlEditView } from '../controlpanel/editMode/pages/SCBControlEditView';

const TAG = 'SCBStatusBarWrapper';
const STATUS_BAR_SCENE_NAME = 'SCBStatusBar';
const GESTURE_BARR_SCENE_NAME = 'SCBGestureBar';

@Component
export struct SCBStatusBarWrapper {
  @Link screenProp: SCBScreenProperty;
  @State dynamicPluginInfoPanels: Array<PluginInfo> = [];
  @State controlCenterPcModePluginInfoPanels: Array<PluginInfo> = [];
  @State dynamicAccessPluginInfoPanels: Array<PluginAccessInfo> = [];
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  @State contentColor: string = '#FFFFFF';
  zOrder = 1;
  rebootDialogName: string = 'reboot';
  shutDownDialogName: string = 'shutdown';

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, start`);
    mSystemPanelModel.confirmLogout = () => this.onConfirmLogout(); // 绑定确认退出登录弹窗
    if (CommonUtils.isInvalid(statusbarPlCtrl)) {
      Log.showInfo(TAG, `statusbarPlCtrl is invalid`);
    }
    statusbarPlCtrl.init();
    StatusBarPanelManager.getInstance().init();
    StatusBarEventManager.getInstance().onSpecial(TAG, StatusBarEventId.PANEL_CHANGE_EVENT, this.onPanelChangeEvent);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyCallback);
    this.eventMgr.on(AccessPanelHeightChangeEvent, (event) => this.onRequestWindowHeightEvent(event));
    this.dynamicPluginInfoPanels = PluginWindowManager.getInstance().getDynamicPanels();
    this.controlCenterPcModePluginInfoPanels = ControlCenterPcModePluginPanelMgr.getInstance().getPanels();
    this.dynamicAccessPluginInfoPanels = PluginWindowManager.getInstance().getAccessPanels();
    PluginComponentMgr.init();
    mSystemPanelModel.openPowerOffDialog = (dialogName: string) => {
      this.handleOpenPowerOffDialog(dialogName);
    }
    WallpaperModel.getInstance().registerContentColorListener(TAG, this);
    WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`);
    StatusBarPanelManager.getInstance().destory();
    StatusBarEventManager.getInstance().offAll(TAG);
    WallpaperModel.getInstance().unRegisterContentColorListener(TAG);
    this.eventMgr.offAll();
  }

  private screenPropertyCallback = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    if (reason === SCBPropertyChangeReason.ROTATION) {
      // 旋转时关闭窗口
      let windowName = statusbarPlCtrl.getCurWindow();
      windowMgr.hideWindowImmediately(windowName);
      Log.showInfo(TAG, `hide window: ${windowName} in rotating`);
    }
  }

  handleOpenPowerOffDialog(dialogName: string) {
    Log.showInfo(TAG, `show dialogName: ${dialogName}`);
    viewMgrPolicy.showView(ViewType.DIALOG_VIEW);
  }

  onConfirmLogout(): Promise<boolean> {
    return new Promise((resolve) => {
      mSystemPanelModel.setCurrentClickItem(Constants.LOGOUT);
      Log.showInfo(TAG, 'show dialogName: logout');
      viewMgrPolicy.showView(ViewType.DIALOG_VIEW);
    });
  }

  onContentColorChange(newContentColor: string): void {
    Log.showInfo(TAG, `desktop wallerpaper changed, newContentColor is ${newContentColor}`);
    if (CommonUtils.isEmpty(newContentColor)) {
      Log.showInfo(TAG, 'contentColor is invalid');
      return;
    }
    if (this.contentColor !== newContentColor) {
      Log.showInfo(TAG, `new contentColor is ${newContentColor}, old contentColor is ${this.contentColor}`);
      this.contentColor = newContentColor;
    }
  }

  getRegion(): Array<number> {
    // 默认全屏
    let screenHeight = AppStorage.get<number>('screenHeight');
    if (!screenHeight) {
      Log.showInfo(TAG, 'getRegion full wallpaper region');
      return [0, 0, 1, 1];
    }
    const bottom: number = Math.round(styleMgr.vp2pxStatusBarPCHeight()) / screenHeight;
    Log.showInfo(TAG, 'getRegion ' + bottom);
    return [0, 0, 1, bottom];
  }
  /**
   * 音量二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  soundPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      SCBSoundPanel({
        persistentId: $$.persistentId
      })
    }
  }

  /**
   * 系统二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  systemPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      SCBSystemPanel({
        persistentId: $$.persistentId
      })
    }
  }

  /**
   * 控制中心编辑页面
   *
   * @param $$ SCBSystemScene入参
   */
  @Builder
  editModePanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      SCBControlEditView({ persistentId: $$.persistentId, screenProp: $$.screenProp })
    }
  }

  /**
   * 输入法:语言二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  inputMethodSubtypePanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      SCBInputMethodSubtypePanel({
        persistentId: $$.persistentId,
        screenProp: this.screenProp
      })
    }
  }

  /**
   * 输入法二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  inputMethodPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      SCBInputMethodPanel({
        persistentId: $$.persistentId
      })
    }
  }

  /**
   * 相机二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  cameraPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      SCBCameraPanel({
        persistentId: $$.persistentId,
      })
    }
  }

  /**
   * 麦克风二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  microphonePanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      SCBMicrophonePanel({
        persistentId: $$.persistentId,
      })
    }
  }

  /**
   * pc超级隐私二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  pcSuperPrivacyBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      SCBSuperPrivacyPanel({
        viewType: ViewType.PC_SUPER_PRIVACY_PANEL,
        windowName: PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT,
        persistentId: $$.persistentId,
      })
    }
  }

  /**
   * pc拨片超级隐私二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  pcPaddleSuperPrivacyBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      SCBSuperPrivacyPanel({
        viewType: ViewType.PC_PADDLE_SUPER_PRIVACY_PANEL,
        windowName: PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE,
        persistentId: $$.persistentId,
      })
    }
  }

  /**
   * 电池二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  batteryPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      SCBBatteryPanel({
        persistentId: $$.persistentId
      })
    }
  }

  /**
   * PC模式播控中心二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  mediaPlayPanelBuilder($$: SystemSceneBuilderParam) {
    SCBMediaPlayPanel({
      persistentId: $$.persistentId
    })
  }

  /**
   * 省电模式二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  pluginPowerSavingPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      AbilityRootComponent({
        pluginViewType: ViewType.POWER_SAVING,
        persistentId: $$.persistentId
      });
    }
  }

  /**
   * 组合通知中心二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  assemblyPanelBuilder($$: SystemSceneBuilderParam) {
    SCBAssemblyPanel({
      persistentId: $$.persistentId,
      screenProp: $$.screenProp,
    })
  }

  /**
   * 控制中心二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  controlPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      SCBControlPanel({
        persistentId: $$.persistentId
      })
    }
  }

  /**
   * 托盘二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  trayPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
      isTrayPanel: true
    }) {
      SCBTrayPanel({
        persistentId: $$.persistentId
      })
    }
  }

  /**
   * 系统接入应用二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  dynamicPluginPanelBuilder(item: PluginInfo, $$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      DynamicPluginRootComponent({
        pluginInfo: item,
        persistentId: $$.persistentId
      })
    }
  }

  /**
   * 控制中心接入应用二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  controlCenterPcModePluginPanelBuilder(item: PluginInfo, $$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      PcModePluginRootComponent({
        pluginInfo: item,
        persistentId: $$.persistentId
      })
    }
  }

  /**
   * 生态接入应用二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  dynamicPluginAccessPanelBuilder(item: PluginAccessInfo, $$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      DynamicPluginAccessComponent({
        pluginInfo: item,
        persistentId: $$.persistentId
      })
    }
  }

  /**
   * WiFi二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  pluginWifiPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      AbilityRootComponent({
        pluginViewType: ViewType.PLUGIN_WIFI,
        persistentId: $$.persistentId
      });
    }
  }

  /**
   * 蓝牙二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  pluginBluetoothPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      AbilityRootComponent({
        pluginViewType: ViewType.PLUGIN_BLUETOOTH,
        persistentId: $$.persistentId
      });
    }
  }

  /**
   * 企业空间切换二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  enterpriseSpaceBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      SCBEnterpriseSpacePanel({
        persistentId: $$.persistentId,
      })
    }
  }

  /**
   * Location二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  pluginLocationPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      AbilityRootComponent({
        pluginViewType: ViewType.PLUGIN_LOCATION,
        persistentId: $$.persistentId
      });
    }
  }

  /**
   * USB二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  pluginUSBPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      USBPanel({
        persistentId: $$.persistentId
      });
    }
  }

  /**
   * 隐私指示器二级菜单
   * @param $$ SCBSystemScene入参
   */
  @Builder
  pluginPrivacyPanelBuilder($$: SystemSceneBuilderParam) {
    SCBSystemSceneLayout({
      persistentId: $$.persistentId,
    }) {
      PrivacyPluginRootComponent({
        pluginViewType: ViewType.SLOT_CONTROL_PRIVACY_PANEL,
        persistentId: $$.persistentId,
      })
    }
  }

  /**
   * 状态栏根组件
   * @param $$ SCBSystemScene入参
   */
  @Builder
  gestureBarBuilder($$: SystemSceneBuilderParam) {
    SCBGestureBar({
      persistentId: $$.persistentId,
      screenProp: $$.screenProp,
    })
  }

  @Builder
  defaultSystemSceneBuilder(contextBuilder: ($$: SystemSceneBuilderParam) => void,
    systemType: sceneSessionManager.SessionType,
    sceneName: string, sceneZIndex: number, enableActiveModeChange: boolean = false) {
    SCBSystemScene({
      contextBuilder: contextBuilder,
      systemSessionInfo: {
        systemType: systemType,
        sceneName: sceneName,
        sceneZIndex: sceneZIndex,
        isFocusable: sceneName === GESTURE_BARR_SCENE_NAME ? false : true,
        isTouchable: true,
        isRotatable: false,
        hitTestMode: HitTestMode.Default,
        sceneType: sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE,
        enableActiveModeChange: enableActiveModeChange
      },
      screenProperty: this.screenProp,
      transitionCallBack: () => {
        return this.getTransitionEffect(sceneName)
      }
    })
  }

  /**
   * 系统窗口组件
   * @param $$ SCBSystemScene入参
   */
  @Builder
  systemSceneBuilder(contextBuilder: ($$: SystemSceneBuilderParam) => void,
    systemType: sceneSessionManager.SessionType,
    sceneName: string, sceneZIndex: number, enableActiveModeChange: boolean = false) {
    if (systemType === sceneSessionManager.SessionType.TYPE_STATUS_BAR) {
      SCBSystemScene({
        contextBuilder: contextBuilder,
        systemSessionInfo: {
          systemType: systemType,
          sceneName: sceneName,
          sceneZIndex: sceneZIndex,
          isFocusable: false,
          isTouchable: true,
          isRotatable: false,
          hitTestMode: HitTestMode.Default,
          systemBarType: SystemBarType.STATUS_BAR,
          sceneType: sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE,
          enableActiveModeChange: enableActiveModeChange
        },
        screenProperty: this.screenProp,
        transitionCallBack: sceneName === STATUS_BAR_SCENE_NAME ? undefined : () => {
          return this.getTransitionEffect(sceneName)
        }
      })
    } else {
      SCBSystemScene({
        contextBuilder: contextBuilder,
        systemSessionInfo: {
          systemType: systemType,
          sceneName: sceneName,
          sceneZIndex: sceneZIndex,
          isFocusable: true,
          isTouchable: true,
          isRotatable: false,
          hitTestMode: HitTestMode.Default,
          borderRadius: WindowConstants.WINDOW_CORNER_RADIUS,
          shadow: {
            radius: WindowConstants.PC_SECONDARY_WINDOW_SHADOW_RADIUS,
            color: WindowConstants.PC_SECONDARY_WINDOW_SHADOW_COLOR,
            offsetX: WindowConstants.SHADOW_OFFSET_X,
            offsetY: WindowConstants.PC_SECONDARY_WINDOW_SHADOW_OFFSET_Y
          },
          sceneType: sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE,
          enableActiveModeChange: enableActiveModeChange
        },
        screenProperty: this.screenProp,
        transitionCallBack: sceneName === STATUS_BAR_SCENE_NAME ? undefined : () => {
          return this.getTransitionEffect(sceneName)
        }
      })
    }
  }

  /**
   * 将缩放值转为字符串形式百分数
   * @param value 缩放比
   * @returns
   */
  toPercentage(value: number): string {
    value = value > 1 ? 1 : value;
    value = value < 0 ? 0 : value;
    return `${(value * 100).toFixed(0)}%`;
  }

  /**
   * 获取锚点信息，X轴上位置
   * @param windowName 窗口名
   * @returns
   */
  getAnimPivotX(windowName: string) {
    let pivotX: number = windowMgr.getWindowAnimPivot(windowName)[0] ?? 0;
    return this.toPercentage(pivotX);
  }

  /**
   * 获取锚点信息，y轴上位置
   * @param windowName 窗口名
   * @returns
   */
  getAnimPivotY(windowName: string) {
    let pivotY: number = windowMgr.getWindowAnimPivot(windowName)[1] ?? 0;
    return this.toPercentage(pivotY);
  }

  build() {
    WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.trayPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_TRAY_PANEL,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      // 状态栏二级菜单
      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.systemPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_PERSONAL,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.soundPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_VOLUME_OVERLAY, PluginSlot.SLOT_STATUS_SOUND_PANEL,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.inputMethodSubtypePanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_INPUT_PANEL,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.inputMethodPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_INPUT_METHOD,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.cameraPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_CAMERA,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.microphonePanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_MICROPHONE_PANEL,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.batteryPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_BATTERY_PANEL,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      if (ModeChangeUtils.isPcMode()) {
        this.defaultSystemSceneBuilder(($$: SystemSceneBuilderParam) => {
          this.mediaPlayPanelBuilder($$)
        },
          sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_CONTROL_MEDIA_PLAY_PANEL,
          SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))
      }

      this.defaultSystemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.assemblyPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.editModePanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL,
        PluginSlot.SLOT_STATUS_EDIT_MODE_PANEL,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.editModePanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL,
        PluginSlot.SLOT_STATUS_EDIT_MODE_PANEL,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.controlPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL,
        PluginSlot.SLOT_STATUS_CONTROL_CENTER,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      ForEach(this.dynamicPluginInfoPanels, (item: PluginInfo) => {
        this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
          this.dynamicPluginPanelBuilder(item, $$)
        },
          sceneSessionManager.SessionType.TYPE_PANEL, item.pluginParseInfo.pluginSlot,
          SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))
      }, (item: PluginInfo) => JSON.stringify(item))

      ForEach(this.controlCenterPcModePluginInfoPanels, (item: PluginInfo) => {
        this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
          this.controlCenterPcModePluginPanelBuilder(item, $$)
        },
          sceneSessionManager.SessionType.TYPE_PANEL, item.pluginParseInfo.pluginSlot,
          SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))
      }, (item: PluginInfo) => JSON.stringify(item))

      ForEach(this.dynamicAccessPluginInfoPanels, (item: PluginAccessInfo) => {
        this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
          this.dynamicPluginAccessPanelBuilder(item, $$)
        },
          sceneSessionManager.SessionType.TYPE_PANEL, item.getSlot(),
          SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))
      }, (item: PluginAccessInfo) => JSON.stringify(item));

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.pluginWifiPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_WIFI_PANEL,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.pluginBluetoothPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      // 位置权限的二级面板
      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.pluginLocationPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_LOCATION,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      // USB的二级面板
      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.pluginUSBPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_USB,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.pluginPrivacyPanelBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_CONTROL_PRIVACY_PANEL,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.defaultSystemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.gestureBarBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, GESTURE_BARR_SCENE_NAME,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.defaultSystemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.enterpriseSpaceBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.pcSuperPrivacyBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))

      this.systemSceneBuilder(($$: SystemSceneBuilderParam) => {
        this.pcPaddleSuperPrivacyBuilder($$)
      },
        sceneSessionManager.SessionType.TYPE_PANEL, PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE,
        SCBDefaultZIndex.STATUS_BAR + (++this.zOrder))
    }
    .zIndex(SCBDefaultZIndex.STATUS_BAR)
    .width('100%')
    .height(styleMgr.vp2pxStatusBarPCHeight())
    .hitTestBehavior(HitTestMode.None)
  }

  /**
   * 二级面板变更事件
   */
  private onPanelChangeEvent = (event: PanelChangeEvent): void => {
    if (!event) {
      Log.showError(TAG, 'PanelChangeEvent error');
      return;
    }
    if (event.eventType === 'dynamic') {
      this.dynamicPluginInfoPanels = event.panelInfos;
    }
    if (event.eventType === 'access') {
      let panelInfos = event.panelInfos as PluginAccessInfo[];
      if (!panelInfos) {
        Log.showError(TAG, 'panelInfo error');
        return;
      }
      const index = panelInfos.findIndex(res => (res.accessTokenId === event.tokenId &&
        res.pluginParseInfo.instanceKey === event.instanceKey));
      const windowHeight = event.height ?? -1;
      if (index > -1 && windowHeight > 0 &&
        event.panelInfos.length === this.dynamicAccessPluginInfoPanels.length) {
        this.dynamicAccessPluginInfoPanels[index].pluginParseInfo.clickInfo.windowHeight = windowHeight;
      } else {
        this.dynamicAccessPluginInfoPanels = event.panelInfos as PluginAccessInfo[];
      }
    }
    Log.showInfo(TAG, `PanelChangeEvent ${event.eventType} length:${event.panelInfos.length}`)
  }

  onRequestWindowHeightEvent(event: AccessPanelHeightChangeEvent): void {
    const index = this.dynamicAccessPluginInfoPanels.findIndex(res => (res.accessTokenId === event.tokenId &&
      res.pluginParseInfo.instanceKey === event.instanceKey));
    const windowHeight = event.windowHeight ?? -1;
    if (index > -1 && windowHeight > 0) {
      this.dynamicAccessPluginInfoPanels[index].pluginParseInfo.clickInfo.windowHeight = windowHeight;
    }
  }

  onBackPress(): boolean {
    return true;
  }

  /**
   * 窗口进场动效
   */
  private getTransitionEffect = (windowName: string): TransitionEffect => {
    const pivotX: string = this.getAnimPivotX(windowName);
    const pivotY: string = this.getAnimPivotY(windowName);
    return TransitionEffect.asymmetric(
      TransitionEffect.scale({
        x: StatusBarAnimConstants.SCALE,
        y: StatusBarAnimConstants.SCALE,
        centerX: pivotX,
        centerY: pivotY
      })
        .animation({
          curve: Curves.springMotion(StatusBarAnimConstants.SPRING_MOTION_RESPONSE,
            StatusBarAnimConstants.SPRING_MOTION_DAMP)
        })
        .combine(TransitionEffect.OPACITY.animation({
          duration: StatusBarAnimConstants.INSERT_OPACITY_DURATION,
          curve: Curve.Friction
        }))
      ,
      TransitionEffect.scale({
        x: StatusBarAnimConstants.SCALE,
        y: StatusBarAnimConstants.SCALE,
        centerX: pivotX,
        centerY: pivotY
      })
        .animation({
          curve: Curves.springMotion(StatusBarAnimConstants.SPRING_MOTION_RESPONSE,
            StatusBarAnimConstants.SPRING_MOTION_DAMP)
        })
        .combine(TransitionEffect.OPACITY.animation({
          duration: StatusBarAnimConstants.DEL_OPACITY_DURATION,
          curve: Curve.Friction
        }))
    );
  }
}