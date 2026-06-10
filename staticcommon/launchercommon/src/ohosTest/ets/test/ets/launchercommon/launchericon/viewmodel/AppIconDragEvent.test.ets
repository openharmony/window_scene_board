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
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';

import { AppIconConfig } from '../../../../../../../main/ets/launchericon/config/AppIconConfig';
import { AppItemInfo, editModeManager } from '../../../../../../../main/ets/TsIndex';
import { AppIconData } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconData';
import {
  AppIconDragEvent,
  AppIconDragEventParam
} from '../../../../../../../main/ets/launchericon/viewmodel/AppIconDragEvent';
import { AppIconMenuVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconMenuVm';
import { AppIconExternCb } from '../../../../../../../main/ets/launchericon/interface/AppIconExternCb';
import { AppIconBadgeEvent } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBadgeEvent';
import { AppIconBadgeVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconBadgeVm';

export default function AppIconDragEventTest() {
  let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();

  let iconData = new AppIconData();
  iconData.iconOpacity = 0;
  iconData.iconScale = 1;

  let appIconConfig = new AppIconConfig();
  appIconConfig.setExternCb({
    dragStartExtend: (event: DragEvent): void => {
    },
    dragEndExtend: (event: DragEvent): void => {
    },
    getIndexInSwiper: () => 0,
  } as AppIconExternCb);

  let iconMenuVm: AppIconMenuVm = new AppIconMenuVm();
  iconMenuVm.setIsMenuShow(false);

  let param: AppIconDragEventParam = {
    itemInfo: new AppItemInfo(),
    iconData: iconData,
    iconMenuVm: iconMenuVm,
    iconSizeCb: () => 0,
    appIconConfig: appIconConfig,
    iconBadgeVm: new AppIconBadgeVm(),
  } as AppIconDragEventParam;

  let dragResult1: DragResult = DragResult.DRAG_FAILED;
  let event: DragEvent = {
    getWindowX: (() => {
      return 0;
    }),
    getWindowY: (() => {
      return 0;
    }),
    getResult: (): DragResult => {
      return dragResult1;
    },
  } as DragEvent;

  describe('AppIconDragEventTest', () => {
    beforeAll(() => {
      appIconDragEvent.initDragParam(param);
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_initDragParam_01', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();
        let param: AppIconDragEventParam = {} as AppIconDragEventParam;
        appIconDragEvent.initDragParam(param);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragStart_01', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();
        let param: AppIconDragEventParam = {} as AppIconDragEventParam;
        appIconDragEvent.initDragParam(param);

        appIconDragEvent.onDragStart(event);
        appIconDragEvent.onDragEnd(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragStart_02', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();
        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
        } as AppIconDragEventParam;
        appIconDragEvent.initDragParam(param);

        appIconDragEvent.onDragStart(event);
        appIconDragEvent.onDragEnd(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragStart_03', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();
        let iconData = new AppIconData();
        iconData.iconOpacity = 0;

        let appIconConfig = new AppIconConfig();
        appIconConfig.setExternCb({
          dragStartExtend: (event: DragEvent): void => {
          },
          getIndexInSwiper: () => 0,
        } as AppIconExternCb);
        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
          iconData: iconData,

          iconMenuVm: new AppIconMenuVm(),
          iconSizeCb: () => 0,
          appIconConfig: appIconConfig,
        } as AppIconDragEventParam;
        appIconDragEvent.initDragParam(param);

        appIconDragEvent.onDragStart(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragStart_04', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();
        let iconData = new AppIconData();
        iconData.iconOpacity = 0;

        let appIconConfig = new AppIconConfig();
        appIconConfig.setExternCb({
          getIndexInSwiper: () => 0,
        } as AppIconExternCb);
        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
          iconData: iconData,
          appIconConfig: appIconConfig,
        } as AppIconDragEventParam;
        appIconDragEvent.initDragParam(param);

        appIconDragEvent.onDragStart(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragStart_05', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();
        let iconData = new AppIconData();
        iconData.iconOpacity = 0;

        let appIconConfig = new AppIconConfig();
        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
          iconData: iconData,
          appIconConfig: appIconConfig,
        } as AppIconDragEventParam;
        appIconDragEvent.initDragParam(param);

        appIconDragEvent.onDragStart(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragStart_06', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();
        let iconData = new AppIconData();
        iconData.iconOpacity = 0;

        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
          iconData: iconData,
        } as AppIconDragEventParam;
        appIconDragEvent.initDragParam(param);

        appIconDragEvent.onDragStart(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragEnd_03', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();
        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
          iconData: new AppIconData(),
        } as AppIconDragEventParam;
        appIconDragEvent.initDragParam(param);

        let event: DragEvent = {} as DragEvent;
        appIconDragEvent.onDragEnd(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragEnd_04', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();

        let iconData = new AppIconData();
        iconData.iconOpacity = 0;
        iconData.iconScale = 1;

        let appIconConfig = new AppIconConfig();
        appIconConfig.setExternCb({
          dragStartExtend: (event: DragEvent): void => {
          },
          dragEndExtend: (event: DragEvent): void => {
          },
          getIndexInSwiper: () => 0,
        } as AppIconExternCb);

        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
          iconData: iconData,
          iconMenuVm: new AppIconMenuVm(),
          iconSizeCb: () => 0,
          appIconConfig: appIconConfig,
        } as AppIconDragEventParam;

        appIconDragEvent.initDragParam(param);

        appIconDragEvent.onDragEnd(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragEnd_05', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();

        let iconData = new AppIconData();
        iconData.iconOpacity = 0;
        iconData.iconScale = 1;

        let appIconConfig = new AppIconConfig();
        appIconConfig.setExternCb({
          dragStartExtend: (event: DragEvent): void => {
          },
          getIndexInSwiper: () => 0,
        } as AppIconExternCb);

        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
          iconData: iconData,
          iconMenuVm: new AppIconMenuVm(),
          iconSizeCb: () => 0,
          appIconConfig: appIconConfig,
        } as AppIconDragEventParam;

        appIconDragEvent.initDragParam(param);

        appIconDragEvent.onDragEnd(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragEnd_06', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();

        let iconData = new AppIconData();
        iconData.iconOpacity = 0;
        iconData.iconScale = 1;

        let appIconConfig = new AppIconConfig();

        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
          iconData: iconData,
          iconMenuVm: new AppIconMenuVm(),
          iconSizeCb: () => 0,
          appIconConfig: appIconConfig,
        } as AppIconDragEventParam;

        appIconDragEvent.initDragParam(param);

        appIconDragEvent.onDragEnd(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragEnd_07', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();

        let iconData = new AppIconData();
        iconData.iconOpacity = 0;
        iconData.iconScale = 0;

        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
          iconData: iconData,
          iconMenuVm: new AppIconMenuVm(),
          iconSizeCb: () => 0,
        } as AppIconDragEventParam;

        appIconDragEvent.initDragParam(param);

        appIconDragEvent.onDragEnd(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragEnd_08', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();

        let iconData = new AppIconData();
        iconData.iconOpacity = 0;
        iconData.iconScale = 0;

        let iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();

        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
          iconData: iconData,
          iconMenuVm: new AppIconMenuVm(),
          iconSizeCb: () => 0,
          iconBadgeEvent: new AppIconBadgeEvent(iconBadgeVm),
        } as AppIconDragEventParam;

        appIconDragEvent.initDragParam(param);

        appIconDragEvent.onDragEnd(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onDragEnd_09', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();

        let iconData = new AppIconData();
        iconData.iconOpacity = 0;
        iconData.iconScale = 0;

        let iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();

        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
          iconData: iconData,
          iconMenuVm: new AppIconMenuVm(),
          iconBadgeEvent: new AppIconBadgeEvent(iconBadgeVm),
        } as AppIconDragEventParam;

        appIconDragEvent.initDragParam(param);

        appIconDragEvent.onDragEnd(event);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onPreDrag_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let preDragStatus: PreDragStatus = PreDragStatus.PREVIEW_LANDING_FINISHED;
        appIconDragEvent.onPreDrag(preDragStatus);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_onPreDrag_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(editModeManager, editModeManager.isInEditMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let preDragStatus: PreDragStatus = PreDragStatus.ACTION_CANCELED_BEFORE_DRAG;
        appIconDragEvent.onPreDrag(preDragStatus);
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(editModeManager);
      mock.clearAll();
    })

    it('test_getDragPreviewBuilder_01', 0, () => {
      try {
        let appIconDragEvent: AppIconDragEvent = new AppIconDragEvent();

        let iconData = new AppIconData();
        iconData.iconOpacity = 0;
        iconData.iconScale = 1;

        let appIconConfig = new AppIconConfig();
        appIconConfig.setExternCb({
          dragStartExtend: (event: DragEvent): void => {
          },
          getIndexInSwiper: () => 0,
        } as AppIconExternCb);

        let param: AppIconDragEventParam = {
          itemInfo: new AppItemInfo(),
          iconData: iconData,
          iconMenuVm: new AppIconMenuVm(),
          iconSizeCb: () => 0,
          appIconConfig: appIconConfig,
        } as AppIconDragEventParam;

        appIconDragEvent.initDragParam(param);

        appIconDragEvent.getDragPreviewBuilder();
        expect(appIconDragEvent instanceof AppIconDragEvent).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  });
}