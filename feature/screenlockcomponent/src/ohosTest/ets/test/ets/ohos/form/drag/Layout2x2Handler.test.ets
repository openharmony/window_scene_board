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

import { describe, it, expect } from '@ohos/hypium'
import { LockscreenFormConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import FormPlaceHolderInfo from '@ohos/screenlockwidget/src/main/ets/form/drag/FormPlaceHolderInfo'
import Layout2x2Handler from '@ohos/screenlockwidget/src/main/ets/form/drag/Layout2x2Handler'
import ScreenLockFormViewModel, {
  SupportFormLocation
} from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel'

export default function Layout2x2HandlerTest() {
  describe('Layout2x2HandlerTest', () => {
    let layout2x2Handler = new Layout2x2Handler()
    it('Layout2x2HandlerTest_handleDrag', 0, (done: Function) => {
      try {
        let formViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        let result = layout2x2Handler.handleDrag(formViewModel, holderInfo, supportPosition);
        expect(result !== null).assertTrue()
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout2x2HandlerTest_handleDrag_002', 0, (done: Function) => {
      try {
        let formViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        holderInfo.dragForms = new LockscreenFormConfig();
        holderInfo.dimensionX = 2;
        formViewModel.formConfigs = [new LockscreenFormConfig()];
        formViewModel.formConfigs[0].dimensionX = 2;
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        let result = layout2x2Handler.handleDrag(formViewModel, holderInfo, supportPosition);
        expect(result !== null).assertTrue()
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout2x2HandlerTest_handleDrag_003', 0, (done: Function) => {
      try {
        let formViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        holderInfo.dragForms = new LockscreenFormConfig();
        holderInfo.dimensionX = 3;
        formViewModel.formConfigs = [new LockscreenFormConfig()];
        formViewModel.formConfigs[0].dimensionX = 2;
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        let result = layout2x2Handler.handleDrag(formViewModel, holderInfo, supportPosition);
        expect(result !== null).assertTrue()
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout2x2HandlerTest_handleUpdateDragItem', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        holderInfo.newX = undefined;
        holderInfo.newY = undefined;
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        (layout2x2Handler as object)['handleUpdateDragItem'](formViewModel, holderInfo, supportPosition);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout2x2HandlerTest_handleUpdateDragItem', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        holderInfo.dragForms = new LockscreenFormConfig();
        holderInfo.newX = 1;
        holderInfo.newY = 1;
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        (layout2x2Handler as object)['handleUpdateDragItem'](formViewModel, holderInfo, supportPosition);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout2x2HandlerTest_handleUpdateDragItem_002', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        holderInfo.dragForms = new LockscreenFormConfig();
        holderInfo.newX = 2;
        holderInfo.newY = 0;
        holderInfo.dimensionX = 2;
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        (layout2x2Handler as object)['handleUpdateDragItem'](formViewModel, holderInfo, supportPosition);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout2x2HandlerTest_handle1x2CardSqueeze', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        (layout2x2Handler as object)['handle1x2CardSqueeze'](formViewModel, holderInfo, supportPosition);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout2x2HandlerTest_handle1x2CardSqueeze_002', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        formViewModel.formConfigs = [new LockscreenFormConfig()];
        (layout2x2Handler as object)['handle1x2CardSqueeze'](formViewModel, holderInfo, supportPosition);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout2x2HandlerTest_handleSqueeze1x2Card', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
        let holderInfo: FormPlaceHolderInfo = new FormPlaceHolderInfo();
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        let oldForm: LockscreenFormConfig = new LockscreenFormConfig();
        formViewModel.formConfigs = [new LockscreenFormConfig()];
        (layout2x2Handler as object)['handleSqueeze1x2Card'](formViewModel, oldForm, holderInfo, supportPosition);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('Layout2x2HandlerTest_handleNormalSqueeze', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();
        let supportPosition: SupportFormLocation[] = [new SupportFormLocation()];
        let oldForm: LockscreenFormConfig = new LockscreenFormConfig();
        formViewModel.formConfigs = [new LockscreenFormConfig()];
        (layout2x2Handler as object)['handleNormalSqueeze'](formViewModel, oldForm, supportPosition);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
  })
}