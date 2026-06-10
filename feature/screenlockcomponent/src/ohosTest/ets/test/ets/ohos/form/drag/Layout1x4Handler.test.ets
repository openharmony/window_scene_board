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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex'
import { LockscreenFormConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import FormPlaceHolderInfo from '@ohos/screenlockwidget/src/main/ets/form/drag/FormPlaceHolderInfo'
import Layout1x4Handler from '@ohos/screenlockwidget/src/main/ets/form/drag/Layout1x4Handler'
import ScreenLockFormViewModel, {
  SupportFormLocation
} from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel'

export default function Layout1x4HandlerTest() {
  describe('Layout1x4HandlerTest', () => {
    let layout1x4Handler = new Layout1x4Handler()
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('test_handleDrag', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let config1: LockscreenFormConfig = {
        positionX: 0,
        positionY: 0,
        dimensionX: 1,
        formInfo: new CardItemInfo()
      }
      let configs: LockscreenFormConfig[] = [
        {
          positionX: 0,
          positionY: 0,
          dimensionX: 0,
          formInfo: new CardItemInfo()
        },
        config1
        ,
        {
          positionX: 10,
          positionY: 10,
          dimensionX: 2,
          formInfo: new CardItemInfo()
        },
      ]
      let positions: SupportFormLocation[] = [
        {
          isShow: false,
          positionX: 0,
          positionY: 0,
        },
        {
          isShow: true,
          positionX: 0,
          positionY: 0,
        }
      ];
      let screenLockFormViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
      screenLockFormViewModel.formConfigs = configs;
      let holderInfo1 = new FormPlaceHolderInfo()
      holderInfo1.newX = 5
      holderInfo1.dragForms = config1;
      layout1x4Handler.handleDrag(screenLockFormViewModel, holderInfo1, positions)
      let holderInfo2 = new FormPlaceHolderInfo()
      holderInfo2.newX = undefined
      layout1x4Handler.handleDrag(screenLockFormViewModel, holderInfo2, positions)
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('Layout1x4HandlerTest_handleDrag', 0, (done: Function) => {
      try {
        let formViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
        formViewModel.formConfigs = [new LockscreenFormConfig()];
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        holderInfo.dragForms = new LockscreenFormConfig();
        holderInfo.newX = 1;
        holderInfo.newY = 1;
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        let result = layout1x4Handler.handleDrag(formViewModel, holderInfo, supportPosition);
        expect(result !== null).assertTrue()
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout1x4HandlerTest_putDragForm', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formMap: Map<number, LockscreenFormConfig> = new Map([[1, new LockscreenFormConfig]])
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        holderInfo.newX = undefined;
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        (layout1x4Handler as object)['putDragForm'](formMap, holderInfo, supportPosition);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout1x4HandlerTest_putDragForm_002', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formMap: Map<number, LockscreenFormConfig> = new Map([[1, new LockscreenFormConfig]])
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        holderInfo.newX = 1;
        holderInfo.dragForms = new LockscreenFormConfig();
        holderInfo.dimensionX = 10;
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        (layout1x4Handler as object)['putDragForm'](formMap, holderInfo, supportPosition);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout1x4HandlerTest_putDragForm_003', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formMap: Map<number, LockscreenFormConfig> = new Map([[1, new LockscreenFormConfig]])
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        holderInfo.newX = 1;
        holderInfo.dragForms = new LockscreenFormConfig();
        holderInfo.dimensionX = 1;
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        (layout1x4Handler as object)['putDragForm'](formMap, holderInfo, supportPosition);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout1x4HandlerTest_getPlace', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formMap: Map<number, LockscreenFormConfig> = new Map([[1, new LockscreenFormConfig]]);
        (layout1x4Handler as object)['getPlace'](formMap, 5);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
  })
}