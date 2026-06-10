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
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { DeviceHelper, ThemeActivationEvent } from '@ohos/frameworkwrapper';
import { ShortcutViewModel, GridLayoutUtil, AppGalleryEventInfo } from '../../../../../../../main/ets/TsIndex';
import { AppStatus, IconCanvasType } from '../../../../../../../main/ets/constants/CommonConstants';
import { AppItemInfo } from '../../../../../../../main/ets/bean/AppItemInfo';
import { AppIconCommonEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconCommonEvent';
import { AppIconData } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconData';
import { AppIconStyleConfig } from '../../../../../../../main/ets/launchericon/config/AppIconStyleConfig';
import { AppIconActiveEventIface } from "../../../../../../../main/ets/launchericon/interface/AppIconActiveEventIface";
import { AppIconTouchEventIface } from '../../../../../../../main/ets/launchericon/interface/AppIconTouchEventIface';
import { AppIconHoverEventIface } from '../../../../../../../main/ets/launchericon/interface/AppIconHoverEventIface';
import {
  AppIconLongPressGestureEventIface
} from '../../../../../../../main/ets/launchericon/interface/AppIconLongPressGestureEventIface';
import { AppIconContextMenuIface } from '../../../../../../../main/ets/launchericon/interface/AppIconContextMenuIface';
import { AppIconDragEventIface } from '../../../../../../../main/ets/launchericon/interface/AppIconDragEventIface';
import {
  AppIconGestureJudgeIface
} from '../../../../../../../main/ets/launchericon/interface/AppIconGestureJudgeIface';
import { AppIconResIface } from '../../../../../../../main/ets/launchericon/interface/AppIconResIface';
import { AppIconConfig } from '../../../../../../../main/ets/launchericon/config/AppIconConfig';
import { AppIconDefaultModifier } from '../../../../../../../main/ets/launchericon/interface/AppIconDefaultModifier';
import {
  AppIconContainerModifier
} from '../../../../../../../main/ets/launchericon/interface/AppIconContainerModifier';
import { AppIconBackplaneVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBackplaneVm';
import { AppIconDisableMaskVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconDisableMaskVm';
import { AppIconBadgeVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { AppIconCloneBadgeVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconCloneBadgeVm';
import { AppIconMenuVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconMenuVm';
import { AppNameVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppNameVm';
import { AppDataWrapper } from '../../../../../../../main/ets/launchericon/common/AppDataWrapper';
import { launcherStatusUtil, SCBTransitionController } from '@ohos/windowscene';
import { AppIconInitParam } from '../../../../../../../main/ets/launchericon/interface/AppIconInitParam';
import { UIContext } from '@kit.ArkUI';
import { AppNameEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppNameEvent';
import { CheckEmptyUtils } from '@ohos/basicutils';
import {
  AppIconTransitionController
} from '../../../../../../../main/ets/launchericon/viewmodel/AppIconTransitionController';

export default function AppIconCommonEventTest() {
  describe('AppIconCommonEventTest', (): void => {
    let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
    let itemInfo: AppItemInfo = new AppItemInfo();
    itemInfo.bundleName = 'com.ohos.contacts';
    let param: AppIconInitParam = {
      itemInfo: itemInfo,
      iconData: new AppIconData(),
      iconConfig: new AppIconConfig(),
      iconSizeCb: (): number => {
        return 10;
      },
      isInDragCb: (): boolean => {
        return true;
      },
      iconModifier: new AppIconDefaultModifier(),
      iconContainerModifier: new AppIconContainerModifier(),
      isShowCancelDialogCb: (isShow: boolean): void => {},
      uiContextCb: new UIContext(),
      longPressImageBuilder: undefined,
      dragIconBuilder: undefined,
      longPressMenuBuilder: undefined,
      rightClickMenuBuilder: undefined,
      isInitIconId: true,
      appNameVm: new AppNameVm(),
      backplaneVm: new AppIconBackplaneVm(),
      disableMaskVm: new AppIconDisableMaskVm(),
      appIconShadowData: undefined,
      appIconDynamicShadowData: undefined,
      iconBadgeVm: new AppIconBadgeVm(),
      iconCloneBadgeVm: new AppIconCloneBadgeVm(),
      iconMenuVm: new AppIconMenuVm()
    }

    beforeAll((): void => {
      appIconTouchEvent.init(param);
    });
    beforeEach((): void => {

    });
    afterEach((): void => {

    });
    afterAll((): void => {
      try {
        (appIconTouchEvent as object)['destroyEventhubEvent']();
        (appIconTouchEvent as object)['destroyViewEvent']();
        appIconTouchEvent.destroy();
      } catch (e) {
      }
    });

    it('should_return_null', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppIconStyleConfig, AppIconStyleConfig.getIconShadowOptions);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      const result = appIconCommonEvent.getIconShadowOptions();
      expect(result).assertNull();
      mocker.ignoreMock(AppIconStyleConfig, AppIconStyleConfig.getIconShadowOptions);
    });

    it('should_log_info_when_status_change', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      appIconCommonEvent.onItemAppStatusChange(AppStatus.INSTALLED);
    });

    it('onActive_should_log_info_when_appIconActiveEvent_is_not_null_and_useDefaultIconShow_is_false', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      appIconCommonEvent.setIconActiveEvent({
        onActive: () => {
        },
        useDefaultIconShow: false
      } as AppIconActiveEventIface);
      appIconCommonEvent.onActive('module', 'caller', 'extra');
    });

    it('onActive_should_log_info_when_appIconActiveEvent_is_not_null_and_useDefaultIconShow_is_true', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      appIconCommonEvent.setIconActiveEvent({
        onActive: () => {
        },
        useDefaultIconShow: true
      } as AppIconActiveEventIface);
      appIconCommonEvent.onActive('module', 'caller', 'extra');
    });

    it('onInactive_should_log_info_when_appIconActiveEvent_is_not_null_and_useDefaultIconShow_is_false', 0,
      () => {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        appIconCommonEvent.setIconActiveEvent({
          onInactive: () => {
          },
          useDefaultIconShow: false
        } as AppIconActiveEventIface);
        appIconCommonEvent.onInactive('module', 'caller', 'extra');
      });

    it('onInactive_should_log_info_when_appIconActiveEvent_is_not_null_and_useDefaultIconShow_is_true', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      appIconCommonEvent.setIconActiveEvent({
        onActive: () => {
        },
        useDefaultIconShow: true
      } as AppIconActiveEventIface);
      appIconCommonEvent.onInactive('module', 'caller', 'extra');
    });

    it('getIconMenuEvent', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      appIconCommonEvent.getIconMenuEvent();
    });

    it('should_set_icon_touch_event_iface', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      let appIconTouchEventIface: AppIconTouchEventIface = {
        onTouch: (event: TouchEvent): void => {
          throw new Error('Function not implemented.');
        },
        onClick: (event?: ClickEvent | undefined): void => {
          throw new Error('Function not implemented.');
        }
      };
      appIconCommonEvent.setIconTouchEventIface(appIconTouchEventIface);
      let result = appIconCommonEvent.getIconTouchEventIface();
      expect(result).assertDeepEquals(appIconTouchEventIface);
    });

    it('should_set_iconContainerTouchEvent_when_appIconTouchEventIface_is_not_null', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      let appIconTouchEventIface: AppIconTouchEventIface = {
        onTouch: (event: TouchEvent): void => {
          throw new Error('Function not implemented.');
        },
        onClick: (event?: ClickEvent | undefined): void => {
          throw new Error('Function not implemented.');
        }
      };
      appIconCommonEvent.setIconContainerEventIface(appIconTouchEventIface);
      let result = appIconCommonEvent.getIconContainerEventIface();
      expect(result).assertDeepEquals(appIconTouchEventIface);
    });

    it('should_set_iconHoverEvent_when_appIconHoverEventIface_is_not_null', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      let appIconHoverEventIface: AppIconHoverEventIface = {
        onHover: (isHover: boolean, event: HoverEvent, updateScale: (scale: number) => void): void => {
          throw new Error('Function not implemented.');
        }
      };
      appIconCommonEvent.setIconHoverEventIface(appIconHoverEventIface);
      let result = appIconCommonEvent.getIconHoverEventIface();
      expect(result).assertDeepEquals(appIconHoverEventIface);
    });

    it('should_set_icon_long_press_gesture_event_when_appIconLongPressGestureEventIface_is_not_null', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      let appIconLongPressGestureEventIface: AppIconLongPressGestureEventIface = {
        onLongPressPreGatherAction: (event: GestureEvent): void => {
          throw new Error('Function not implemented.');
        },
        onLongPressPreGatherActionEnd: (event: GestureEvent): void => {
          throw new Error('Function not implemented.');
        },
        onLongPressSnapshotAction: (event: GestureEvent): void => {
          throw new Error('Function not implemented.');
        },
        onLongPressSnapshotActionEnd: (event: GestureEvent): void => {
          throw new Error('Function not implemented.');
        },
        onLongPressSnapshotActionCancel: (): void => {
          throw new Error('Function not implemented.');
        },
        onLongPressGatherAction: (event: GestureEvent): void => {
          throw new Error('Function not implemented.');
        },
        onLongPressGatherActionEnd: (event: GestureEvent): void => {
          throw new Error('Function not implemented.');
        },
        onLongPressVibrateAction: (event: GestureEvent): void => {
          throw new Error('Function not implemented.');
        },
        onLongPressVibrateActionEnd: (event: GestureEvent): void => {
          throw new Error('Function not implemented.');
        },
        onLongPressVibrateActionCancel: (): void => {
          throw new Error('Function not implemented.');
        },
        onLongPressZoomInAction: (event: GestureEvent): void => {
          throw new Error('Function not implemented.');
        },
        onIconLongPressZoomAnimation: (isZoomOut: boolean, bundleName: string): void => {
          throw new Error('Function not implemented.');
        }
      };
      appIconCommonEvent.setLongPressGestureEventIface(appIconLongPressGestureEventIface);
      let result = appIconCommonEvent.getLongPressGestureEventIface();
      expect(result).assertDeepEquals(appIconLongPressGestureEventIface);
    });

    it('should_set_icon_long_press_context_menu_iface', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      let appIconContextMenuIface: AppIconContextMenuIface = {
        showContextMenu: (): boolean => {
          throw new Error('Function not implemented.');
        },
        getContentBuilder: (): CustomBuilder => {
          throw new Error('Function not implemented.');
        },
        getContextMenuOptions: (): ContextMenuOptions => {
          throw new Error('Function not implemented.');
        },
        onMenuDisappear: (): void => {
          throw new Error('Function not implemented.');
        },
        onMenuAppear: (): void => {
          throw new Error('Function not implemented.');
        }
      };
      appIconCommonEvent.setIconLongPressContextMenuIface(appIconContextMenuIface);
      let result = appIconCommonEvent.getIconLongPressContextMenuIface();
      expect(result).assertDeepEquals(appIconContextMenuIface);
    });

    it('should_set_iconRightClickContextMenu_when_appIconContextMenuIface_is_not_null', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      let appIconContextMenuIface: AppIconContextMenuIface = {
        showContextMenu: (): boolean => {
          throw new Error('Function not implemented.');
        },
        getContentBuilder: (): CustomBuilder => {
          throw new Error('Function not implemented.');
        },
        getContextMenuOptions: (): ContextMenuOptions => {
          throw new Error('Function not implemented.');
        },
        onMenuDisappear: (): void => {
          throw new Error('Function not implemented.');
        },
        onMenuAppear: (): void => {
          throw new Error('Function not implemented.');
        }
      };
      appIconCommonEvent.setIconRightClickContextMenuIface(appIconContextMenuIface);
      let result = appIconCommonEvent.getIconRightClickContextMenuIface();
      expect(result).assertDeepEquals(appIconContextMenuIface);
    });

    it('should_set_iconDragEvent_when_appIconDragEventIface_is_not_null', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      let appIconDragEventIface: AppIconDragEventIface = {
        onDragStart: (event: DragEvent): CustomBuilder | DragItemInfo => {
          throw new Error('Function not implemented.');
        },
        onDragEnd: (event: DragEvent): void => {
          throw new Error('Function not implemented.');
        },
        onPreDrag: (preDragStatus: PreDragStatus): void => {
          throw new Error('Function not implemented.');
        },
        getDragPreviewBuilder: (): string | CustomBuilder | DragItemInfo => {
          throw new Error('Function not implemented.');
        }
      };
      appIconCommonEvent.setIconDragEventIface(appIconDragEventIface);
      let result = appIconCommonEvent.getIconDragEventIface();
      expect(result).assertDeepEquals(appIconDragEventIface);
    });

    it('should_set_iconGestureJudgeEvent_when_appIconGestureJudgeIface_is_not_null', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      let appIconGestureJudgeIface: AppIconGestureJudgeIface = {
        onGestureJudgeBegin: (gestureInfo: GestureInfo, event: BaseGestureEvent): GestureJudgeResult => {
          throw new Error('Function not implemented.');
        }
      };
      appIconCommonEvent.setIconGestureJudgeIface(appIconGestureJudgeIface);
      let result = appIconCommonEvent.getIconGestureJudgeIface();
      expect(result).assertDeepEquals(appIconGestureJudgeIface);
    });

    it('should_set_iconResConfig_correctly', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      let iconResConfig: AppIconResIface = {
        initIconImage: (itemInfo: AppItemInfo, iconData: AppIconData): Promise<void> => {
          throw new Error('Function not implemented.');
        }
      };
      appIconCommonEvent.setIconResIface(iconResConfig);
      let result = appIconCommonEvent.getIconResIface();
      expect(result).assertDeepEquals(iconResConfig);
    });

    it('test_onItemAppStatusChange_01', 0, () => {
      try {
        let iconData: AppIconData = new AppIconData();
        iconData.appStatus = AppStatus.INSTALLED;
        (appIconTouchEvent as object)['iconData'] = iconData;
        appIconTouchEvent.onItemAppStatusChange(AppStatus.PENDING);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onInactive_01', 0, () => {
      try {
        let iconData: AppIconData = new AppIconData();
        iconData.iconOpacity = -1;
        iconData.iconScale = -1;
        (appIconTouchEvent as object)['iconData'] = iconData;
        appIconTouchEvent.onInactive('module', 'caller', 'extra');
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onIconResourceChange_01', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        appIconCommonEvent.onIconResourceChange();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_onIconResourceChange_02', 0, async (done: Function) => {
      try {
        appIconTouchEvent.onIconResourceChange();
        await sleep(500);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_onEqualToDropItemChange_01', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconTouchEvent as object)['iconBadgeVm'] = undefined;
        appIconCommonEvent.onEqualToDropItemChange(true, true);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_onEqualToDropItemChange_02', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['iconBadgeVm'] = new AppIconBadgeVm();
        appIconCommonEvent.onEqualToDropItemChange(true, true);
        expect(appIconCommonEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_onEqualToDropItemChange_03', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['iconBadgeVm'] = new AppIconBadgeVm();
        appIconCommonEvent.onEqualToDropItemChange(true, false);
        expect(appIconCommonEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('should_log_info_when_isDragStart_is_false_and_is_PC', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc)().afterReturn(true);
      appIconCommonEvent.isEqualToDragItemChange(false, true);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
    });

    it('should_log_info_when_isDragStart_is_false_and_not_PC', 0, () => {
      let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc)().afterReturn(false);
      appIconCommonEvent.isEqualToDragItemChange(false, true);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
    });

    it('test_isEqualToDragItemChange_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunc)().afterReturn(false);

        appIconTouchEvent.isEqualToDragItemChange(false, true);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_getMultiSelectIconType_01', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        appIconCommonEvent.getMultiSelectIconType();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getMultiSelectIconType_02', 0, () => {
      try {
        let appIconConfig: AppIconConfig = new AppIconConfig();
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;
        appIconTouchEvent.getMultiSelectIconType();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getMultiSelectIconType_03', 0, () => {
      try {
        let appDataWrapper: AppDataWrapper = new AppDataWrapper();
        let appIconConfig: AppIconConfig = new AppIconConfig();
        appIconConfig.setAppDataOfTransactionController(appDataWrapper);
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;
        appIconTouchEvent.getMultiSelectIconType();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getMultiSelectIconType_04', 0, () => {
      try {
        let appDataWrapper: AppDataWrapper = new AppDataWrapper();
        appDataWrapper.setIsOpenFolder(true);
        let appIconConfig: AppIconConfig = new AppIconConfig();
        appIconConfig.setAppDataOfTransactionController(appDataWrapper);
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;
        appIconTouchEvent.getMultiSelectIconType();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getMultiSelectIconType_05', 0, () => {
      try {
        let appDataWrapper: AppDataWrapper = new AppDataWrapper();
        appDataWrapper.setIsOpenFolder(false);
        let appIconConfig: AppIconConfig = new AppIconConfig();
        appIconConfig.setAppDataOfTransactionController(appDataWrapper);
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;
        appIconTouchEvent.getMultiSelectIconType();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_showImageErrorMessage_01', 0, () => {
      try {
        let error: ImageError = {
          message: 'error'
        } as ImageError;
        appIconTouchEvent.showImageErrorMessage(error);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_handleLocalEvent_01', 0, () => {
      try {
        (appIconTouchEvent as object)['initEventHandleMap']();
        const EVENT_REFRESH_ICON_IMAGE: string = 'launcher.event.REFRESH_ICON_IMAGE';
        let params: string[] = ['1', '2'];
        (appIconTouchEvent as object)['handleLocalEvent'](EVENT_REFRESH_ICON_IMAGE, params);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleLocalEvent_02', 0, () => {
      try {
        (appIconTouchEvent as object)['initEventHandleMap']();
        const EVENT_REFRESH_ICON_IMAGE: string = 'nothing.other';
        let params: string[] = ['1', '2'];
        (appIconTouchEvent as object)['handleLocalEvent'](EVENT_REFRESH_ICON_IMAGE, params);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleLocalEvent_03', 0, () => {
      try {
        (appIconTouchEvent as object)['initEventHandleMap']();
        const EVENT_REFRESH_ICON_IMAGE: string = 'launcher.event.REFRESH_SHORTCUT_IMAGE';
        let params: string[] = ['1', '2'];
        (appIconTouchEvent as object)['handleLocalEvent'](EVENT_REFRESH_ICON_IMAGE, params);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleLocalEvent_04', 0, () => {
      try {
        (appIconTouchEvent as object)['initEventHandleMap']();
        const EVENT_REFRESH_ICON_IMAGE: string = 'launcher.event.REFRESH_SHORTCUT_IMAGE';
        let params: string[] = ['1', '2'];
        (appIconTouchEvent as object)['handleLocalEvent'](EVENT_REFRESH_ICON_IMAGE, params);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleLocalEvent_05', 0, () => {
      try {
        (appIconTouchEvent as object)['initEventHandleMap']();
        const EVENT_REFRESH_ICON_IMAGE: string = `updateIconImage_${itemInfo.bundleName}`;
        let params: string[] = ['1', '2'];
        (appIconTouchEvent as object)['handleLocalEvent'](EVENT_REFRESH_ICON_IMAGE, params);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleRefreshIconImageEvent_01', 0, () => {
      try {
        let params: string[] = [];
        (appIconTouchEvent as object)['handleRefreshIconImageEvent'](appIconTouchEvent, params);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleRefreshIconImageEvent_02', 0, () => {
      try {
        let itemInfo = new AppItemInfo();
        itemInfo.bundleName = 'test';
        (appIconTouchEvent as object)['itemInfo'] = itemInfo;
        let params: string[] = ['test1'];
        (appIconTouchEvent as object)['handleRefreshIconImageEvent'](appIconTouchEvent, params);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleRefreshIconImageEvent_03', 0, () => {
      try {
        let itemInfo = new AppItemInfo();
        itemInfo.bundleName = 'test';
        (appIconTouchEvent as object)['itemInfo'] = itemInfo;

        let params: string[] = ['test'];
        (appIconTouchEvent as object)['handleRefreshIconImageEvent'](appIconTouchEvent, params);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleRefreshIconImageEvent_01', 0, () => {
      try {
        let itemInfo = new AppItemInfo();
        itemInfo.typeId = 1;
        (appIconTouchEvent as object)['itemInfo'] = itemInfo;

        let params: string[] = [];
        (appIconTouchEvent as object)['handleRefreshShortcutImageEvent'](appIconTouchEvent, params);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleRefreshIconImageEvent_02', 0, () => {
      try {
        let itemInfo = new AppItemInfo();
        itemInfo.typeId = 7;
        (appIconTouchEvent as object)['itemInfo'] = itemInfo;

        let params: string[] = [];
        (appIconTouchEvent as object)['handleRefreshShortcutImageEvent'](appIconTouchEvent, params);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleUpdateIconImageEvent_01', 0, () => {
      try {
        let params: string[] = [];
        (appIconTouchEvent as object)['handleUpdateIconImageEvent'](appIconTouchEvent, params);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initTransitionController_01', 0, () => {
      try {
        (appIconTouchEvent as object)['initTransitionController']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initTransitionController_01', 0, () => {
      try {
        (appIconTouchEvent as object)['initIconData'](false);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initTransitionController_02', 0, () => {
      try {
        (appIconTouchEvent as object)['initIconData'](true);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isEnableEffect_01', 0, () => {
      try {
        (appIconTouchEvent as object)['isEnableEffect'](1);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initEventhubEvent_01', 0, () => {
      try {
        let itemInfo = new AppItemInfo();
        itemInfo.keyName = '';
        (appIconTouchEvent as object)['itemInfo'] = itemInfo;

        (appIconTouchEvent as object)['initEventhubEvent']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initEventhubEvent_02', 0, () => {
      try {
        let itemInfo = new AppItemInfo();
        itemInfo.keyName = 'not empty';
        (appIconTouchEvent as object)['itemInfo'] = itemInfo;

        (appIconTouchEvent as object)['initEventhubEvent']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateShortcutIconId_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().getShortcutIconId);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

        (appIconTouchEvent as object)['updateShortcutIconId']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_updateShortcutIconId_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().getShortcutIconId);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(1);

        (appIconTouchEvent as object)['updateShortcutIconId']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ShortcutViewModel.getInstance());
      mock.clearAll();
    })

    it('test_appItemAccessibilityClickEvent_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(launcherStatusUtil, launcherStatusUtil.isCurrentDesktopVisible);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        (appIconTouchEvent as object)['appItemAccessibilityClickEvent']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(launcherStatusUtil);
      mock.clearAll();
    })

    it('test_appItemAccessibilityClickEvent_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(launcherStatusUtil, launcherStatusUtil.isCurrentDesktopVisible);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        (appIconTouchEvent as object)['appItemAccessibilityClickEvent']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(launcherStatusUtil);
      mock.clearAll();
    })

    it('test_clearTimeId_01', 0, () => {
      try {
        (appIconTouchEvent as object)['clearTimeId'](1);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_clearTimeId_02', 0, () => {
      try {
        (appIconTouchEvent as object)['clearTimeId'](-1);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initIconEvents_01', 0, () => {
      try {
        (appIconTouchEvent as object)['initIconEvents'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initIconTouchEvent_01', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconTouchEvent'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initIconTouchEvent_02', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconTouchEvent'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initIconContainerTouchEvent_01', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconContainerTouchEvent'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initIconContainerTouchEvent_02', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconContainerTouchEvent'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initIconHoverEvent_01', 0, () => {
      try {
        let appIconConfig: AppIconConfig = new AppIconConfig();
        appIconConfig.setEnableHoverAnimation(false);
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;
        (appIconTouchEvent as object)['initIconHoverEvent']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initIconHoverEvent_02', 0, () => {
      try {
        let appIconConfig: AppIconConfig = new AppIconConfig();
        appIconConfig.setEnableHoverAnimation(true);
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;
        (appIconTouchEvent as object)['initIconHoverEvent']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initIconHoverEvent_03', 0, () => {
      try {
        let appIconConfig: AppIconConfig = new AppIconConfig();
        appIconConfig.setEnableHoverAnimation(true);
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;
        (appIconTouchEvent as object)['initIconHoverEvent']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initIconLongPressGestureEvent_01', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconLongPressGestureEvent'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initIconLongPressGestureEvent_02', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconLongPressGestureEvent'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initIconLongPressContextMenu_01', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconLongPressContextMenu'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initIconLongPressContextMenu_02', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconLongPressContextMenu'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initIconRightClickContextMenu_01', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconRightClickContextMenu'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initIconRightClickContextMenu_02', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconRightClickContextMenu'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initIconDragEvent_01', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconDragEvent'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initIconDragEvent_02', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconDragEvent'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initIconGestureJudgeEvent_01', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconGestureJudgeEvent'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initIconGestureJudgeEvent_02', 0, () => {
      try {
        let appIconCommonEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconCommonEvent as object)['initIconGestureJudgeEvent'](param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_get_set', 0, () => {
      try {
        appIconTouchEvent.isIconContainerShow();
        appIconTouchEvent.isIconShow();
        appIconTouchEvent.updateRadiusOfTransCtrl(1);
        appIconTouchEvent.getIconShadowViewModel();
        appIconTouchEvent.getIconDynamicShadowEvent();
        appIconTouchEvent.getIconMaskCanvas(IconCanvasType.DRAG_MASK);
        appIconTouchEvent.getIconMaskCanvas(IconCanvasType.TOUCH_MASK);
        appIconTouchEvent.getIconMaskCanvas(IconCanvasType.PRESS_MASK);
        appIconTouchEvent.getIconMaskCanvas(IconCanvasType.DISABLE_MASK);
        appIconTouchEvent.getIconMaskCanvas(IconCanvasType.INSTALL_MASK);
        appIconTouchEvent.getIconMaskCanvas(IconCanvasType.CUSTOM_MASK);
        appIconTouchEvent.getIconMaskCanvas(IconCanvasType.LONG_PRESS_MASK);
        (appIconTouchEvent as object)['registerLocalEventListener']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initIconCanvas_01', 0, () => {
      try {
        let settings: RenderingContextSettings = new RenderingContextSettings(true);
        let componentId: string = 'true';
        (appIconTouchEvent as object)['initIconCanvas'](settings, componentId);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initMultiSelectCb_01', 0, () => {
      try {
        let appIconConfig: AppIconConfig = new AppIconConfig();
        appIconConfig.setEnableMultiSelect(false);
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;
        (appIconTouchEvent as object)['initMultiSelectCb']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initMultiSelectCb_02', 0, () => {
      try {
        let appIconConfig: AppIconConfig = new AppIconConfig();
        appIconConfig.setEnableMultiSelect(true);
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;
        (appIconTouchEvent as object)['initMultiSelectCb']();

        (appIconTouchEvent as object)['appNameEvent'] = undefined;
        (appIconTouchEvent as object)['multiSelectCb']?.onLongPress();
        (appIconTouchEvent as object)['multiSelectCb']?.onShowAppName();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initMultiSelectCb_03', 0, () => {
      try {
        let appIconConfig: AppIconConfig = new AppIconConfig();
        appIconConfig.setEnableMultiSelect(true);
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;
        (appIconTouchEvent as object)['initMultiSelectCb']();

        let appNameVm = new AppNameVm();
        (appIconTouchEvent as object)['appNameEvent'] = new AppNameEvent(appNameVm);
        (appIconTouchEvent as object)['multiSelectCb']?.onLongPress();
        (appIconTouchEvent as object)['multiSelectCb']?.onShowAppName();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initAppNameAnimate_01', 0, () => {
      try {
        let appIconConfig: AppIconConfig = new AppIconConfig();
        appIconConfig.setEnableAppNameTransactionAnimate(true);
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;
        (appIconTouchEvent as object)['initAppNameAnimate']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_init_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
        let param: AppIconInitParam = {} as AppIconInitParam;
        appIconTouchEvent.init(param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_init_02', 0, () => {
      try {
        let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
        let param: AppIconInitParam = {
          iconConfig: new AppIconConfig(),
          itemInfo: new AppItemInfo(),
          iconSizeCb: (): number => {
            return 10;
          },
          isInDragCb: (): boolean => {
            return true;
          },
          iconModifier: new AppIconDefaultModifier(),
          iconContainerModifier: new AppIconContainerModifier(),
        } as AppIconInitParam;
        appIconTouchEvent.init(param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_init_03', 0, () => {
      try {
        let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
        let param: AppIconInitParam = {
          iconData: new AppIconData(),
          itemInfo: new AppItemInfo(),
          iconSizeCb: (): number => {
            return 10;
          },
          isInDragCb: (): boolean => {
            return true;
          },
          iconModifier: new AppIconDefaultModifier(),
          iconContainerModifier: new AppIconContainerModifier(),
        } as AppIconInitParam;
        appIconTouchEvent.init(param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
    it('test_init_04', 0, () => {
      try {
        let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
        let param: AppIconInitParam = {
          iconData: new AppIconData(),
          iconConfig: new AppIconConfig(),
          iconSizeCb: (): number => {
            return 10;
          },
          isInDragCb: (): boolean => {
            return true;
          },
          iconModifier: new AppIconDefaultModifier(),
          iconContainerModifier: new AppIconContainerModifier(),
        } as AppIconInitParam;
        appIconTouchEvent.init(param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
    it('test_init_05', 0, () => {
      try {
        let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
        let param: AppIconInitParam = {
          iconData: new AppIconData(),
          iconConfig: new AppIconConfig(),
          itemInfo: new AppItemInfo(),
          isInDragCb: (): boolean => {
            return true;
          },
          iconModifier: new AppIconDefaultModifier(),
          iconContainerModifier: new AppIconContainerModifier(),
        } as AppIconInitParam;
        appIconTouchEvent.init(param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
    it('test_init_06', 0, () => {
      try {
        let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
        let param: AppIconInitParam = {
          iconData: new AppIconData(),
          iconConfig: new AppIconConfig(),
          itemInfo: new AppItemInfo(),
          iconSizeCb: (): number => {
            return 10;
          },
          iconModifier: new AppIconDefaultModifier(),
          iconContainerModifier: new AppIconContainerModifier(),
        } as AppIconInitParam;
        appIconTouchEvent.init(param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
    it('test_init_07', 0, () => {
      try {
        let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
        let param: AppIconInitParam = {
          iconData: new AppIconData(),
          iconConfig: new AppIconConfig(),
          itemInfo: new AppItemInfo(),
          iconSizeCb: (): number => {
            return 10;
          },
          isInDragCb: (): boolean => {
            return true;
          },
          iconContainerModifier: new AppIconContainerModifier(),
        } as AppIconInitParam;
        appIconTouchEvent.init(param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_init_08', 0, () => {
      try {
        let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
        let param: AppIconInitParam = {
          iconData: new AppIconData(),
          iconConfig: new AppIconConfig(),
          itemInfo: new AppItemInfo(),
          iconSizeCb: (): number => {
            return 10;
          },
          isInDragCb: (): boolean => {
            return true;
          },
          iconModifier: new AppIconDefaultModifier(),
        } as AppIconInitParam;
        appIconTouchEvent.init(param);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateCanvas_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isAppInstalled);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let disableMaskVm: AppIconDisableMaskVm = new AppIconDisableMaskVm();
        disableMaskVm.visible = true;

        let appIconConfig: AppIconConfig = new AppIconConfig();
        appIconConfig.setEnableDisableMask(true);
        appIconConfig.setEnableTouchMask(true);
        appIconConfig.setEnableInstallAnimate(true);
        (appIconTouchEvent as object)['appIconConfig'] = appIconConfig;

        let iconData: AppIconData = new AppIconData();
        iconData.isShowMask = true;
        (appIconTouchEvent as object)['iconData'] = iconData;

        (appIconTouchEvent as object)['updateCanvas']();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(GridLayoutUtil);
      mock.clearAll();
    });

    it('test_listener_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconTouchEvent as object)['listener'].onIconResourceChange();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_callback_01', 0, () => {
      try {
        (appIconTouchEvent as object)['iconSizeCb']?.();
        (appIconTouchEvent as object)['isInDragCb']?.();
        (appIconTouchEvent as object)['isShowCancelDialogCb']?.();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onAppIconActiveEventCb_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconTouchEvent as object)['onAppIconActiveEventCb']?.(true);
        (appIconTouchEvent as object)['onAppIconActiveEventCb']?.(false);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onContainerOpacityChangeCb_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconTouchEvent as object)['onContainerOpacityChangeCb']?.(1);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onAppItemAccessibilityClickEventCb_01', 0, () => {
      try {
        let appIconTouchEvent: AppIconCommonEvent = new AppIconCommonEvent();
        (appIconTouchEvent as object)['onAppItemAccessibilityClickEventCb']?.();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleThemeChangeEvent_01', 0, () => {
      try {
        let event: ThemeActivationEvent = new ThemeActivationEvent();
        event.target = 10;
        (appIconTouchEvent as object)['handleThemeChangeEvent']?.(event);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onRemoveDialogChangeEventCb_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(launcherStatusUtil, launcherStatusUtil.isCurrentDesktopVisible);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        (appIconTouchEvent as object)['test_onRemoveDialogChangeEventCb_01']?.(true);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(launcherStatusUtil);
      mock.clearAll();
    })

    it('test_onRemoveDialogChangeEventCb_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(launcherStatusUtil, launcherStatusUtil.isCurrentDesktopVisible);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        (appIconTouchEvent as object)['test_onRemoveDialogChangeEventCb_01']?.(true);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(launcherStatusUtil);
      mock.clearAll();
    })

    it('test_onAppUpdateEventCb_01', 0, () => {
      try {
        let eventInfo: AppGalleryEventInfo =
          { bundleName: 'test', status: AppStatus.WAIT_FOR_HARMONY } as AppGalleryEventInfo;

        (appIconTouchEvent as object)['onAppUpdateEventCb']?.(eventInfo);
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateIconRadius_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let controller: AppIconTransitionController = new AppIconTransitionController();
        controller.updateIconRadius(1);
        expect(controller instanceof AppIconTransitionController).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_updateIconRadius_02', 0, () => {
      let mock = new MockKit();
      try {
        let controller: AppIconTransitionController = (appIconTouchEvent as object)['iconTransitionController'];
        let transitionController: SCBTransitionController | undefined = (controller as object)['transitionController'];
        transitionController?.onActive();
        transitionController?.onInactive();
        expect(appIconTouchEvent instanceof AppIconCommonEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })


  });
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}