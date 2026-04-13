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

import { AnimateExCallback } from '@ohos/windowscene/Index'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import { aniParamModel } from '../../../../main/ets/default/model/AnimationParameterModel'
import { OpenCloseAnimationViewModel } from '../../../../main/ets/default/viewmodel/OpenCloseAnimationViewModel'

export default function OpenCloseAnimationViewModelTest() {
  describe('OpenCloseAnimationViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('test_constructor', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(model).not().assertNull();
    })

    it('test_breakFolderAnimation', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      for (let folderType = 0; folderType < 32; folderType++) {
        model.breakFolderAnimation(folderType, true);
        model.breakFolderAnimation(folderType, false);
      }
      expect(model).not().assertNull();
    })

    it('test_deleteFolderAnimation', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      for (let folderType = 0; folderType < 32; folderType++) {
        model.deleteFolderAnimation(folderType, true);
        model.deleteFolderAnimation(folderType, false);
      }
      expect(model).not().assertNull();
    })

    it('test_addBottomTextEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let callback: AnimateExCallback = ()=> {};
      for (let folderType = 0; folderType < 32; folderType++) {
        model.addBottomTextEvent(folderType, true, callback);
        model.addBottomTextEvent(folderType, false, callback);

        model.addBottomTextEvent(folderType, true, callback, 1);
        model.addBottomTextEvent(folderType, false, callback, 1);
      }
      expect(model).not().assertNull();
    })

    it('test_addBgEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let callback: AnimateExCallback = ()=> {};
      for (let folderType = 0; folderType < 32; folderType++) {
        model.addBgEvent(folderType, true, callback);
        model.addBgEvent(folderType, false, callback);

        model.addBgEvent(folderType, true, callback, 1);
        model.addBgEvent(folderType, false, callback, 1);
      }
      expect(model).not().assertNull();
    })

    it('test_addIconEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let callback: AnimateExCallback = ()=> {};
      for (let folderType = 0; folderType < 32; folderType++) {
        model.addIconEvent(folderType, true, callback);
        model.addIconEvent(folderType, false, callback);

        model.addIconEvent(folderType, true, callback, 1);
        model.addIconEvent(folderType, false, callback, 1);
      }
      expect(model).not().assertNull();
    })

    it('test_addIconOptEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let callback: AnimateExCallback = ()=> {};
      for (let folderType = 0; folderType < 32; folderType++) {
        model.addIconOptEvent(folderType, true, callback);
        model.addIconOptEvent(folderType, false, callback);

        model.addIconOptEvent(folderType, true, callback, 1);
        model.addIconOptEvent(folderType, false, callback, 1);
      }
      expect(model).not().assertNull();
    })

    it('test_addTitleEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let callback: AnimateExCallback = ()=> {};
      for (let folderType = 0; folderType < 32; folderType++) {
        model.addTitleEvent(folderType, true, callback);
        model.addTitleEvent(folderType, false, callback);

        model.addTitleEvent(folderType, true, callback, 1);
        model.addTitleEvent(folderType, false, callback, 1);
      }
      expect(model).not().assertNull();
    })

    it('test_addBottomTextFinish', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let callback: AnimateExCallback = ()=> {};
      for (let folderType = 0; folderType < 32; folderType++) {
        model.addBottomTextFinish(folderType, true, callback);
        model.addBottomTextFinish(folderType, false, callback);

        model.addBottomTextFinish(folderType, true, callback, 1);
        model.addBottomTextFinish(folderType, false, callback, 1);
      }
      expect(model).not().assertNull();
    })

    it('test_addBgFinish', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let callback: AnimateExCallback = ()=> {};
      for (let folderType = 0; folderType < 32; folderType++) {
        model.addBgFinish(folderType, true, callback);
        model.addBgFinish(folderType, false, callback);

        model.addBgFinish(folderType, true, callback, 1);
        model.addBgFinish(folderType, false, callback, 1);
      }
      expect(model).not().assertNull();
    })

    it('test_addIconFinish', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let callback: AnimateExCallback = ()=> {};
      for (let folderType = 0; folderType < 32; folderType++) {
        model.addIconFinish(folderType, true, callback);
        model.addIconFinish(folderType, false, callback);

        model.addIconFinish(folderType, true, callback, 1);
        model.addIconFinish(folderType, false, callback, 1);
      }
      expect(model).not().assertNull();
    })

    it('test_addIconOptFinish', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let callback: AnimateExCallback = ()=> {};
      for (let folderType = 0; folderType < 32; folderType++) {
        model.addIconOptFinish(folderType, true, callback);
        model.addIconOptFinish(folderType, false, callback);

        model.addIconOptFinish(folderType, true, callback, 1);
        model.addIconOptFinish(folderType, false, callback, 1);
      }
      expect(model).not().assertNull();
    })

    it('test_addTitleFinish', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model: OpenCloseAnimationViewModel =  new OpenCloseAnimationViewModel();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let callback: AnimateExCallback = ()=> {};
      for (let folderType = 0; folderType < 32; folderType++) {
        model.addTitleFinish(folderType, true, callback);
        model.addTitleFinish(folderType, false, callback);

        model.addTitleFinish(folderType, true, callback, 1);
        model.addTitleFinish(folderType, false, callback, 1);
      }
      expect(model).not().assertNull();
    })

    it('test_startFolderAnimation1', 0, () => {
      const mocker: MockKit = new MockKit();
      const model: OpenCloseAnimationViewModel = new OpenCloseAnimationViewModel();
      const findAnimators: Function = mocker.mockFunc(aniParamModel, aniParamModel.findAnimators);
      when(findAnimators)(1).afterReturn([]);
      model.startFolderAnimation(1, false);
      mocker.clear(aniParamModel);
      mocker.clearAll();
      expect(model).not().assertNull();
    })

    it('test_startFolderAnimation2', 0, () => {
      const mocker: MockKit = new MockKit();
      const model: OpenCloseAnimationViewModel = new OpenCloseAnimationViewModel();
      const findAnimators: Function = mocker.mockFunc(aniParamModel, aniParamModel.findAnimators);
      when(findAnimators)(1).afterReturn([{}]);
      model.startFolderAnimation(1, true);
      mocker.clear(aniParamModel);
      mocker.clearAll();
      expect(model).not().assertNull();
    })

    it('test_startFolderAnimation3', 0, () => {
      const mocker: MockKit = new MockKit();
      const model: OpenCloseAnimationViewModel = new OpenCloseAnimationViewModel();
      const findAnimators: Function = mocker.mockFunc(aniParamModel, aniParamModel.findAnimators);
      when(findAnimators)(1).afterReturn([{}, {}]);
      model.startFolderAnimation(1, false);
      mocker.clear(aniParamModel);
      mocker.clearAll();
      expect(model).not().assertNull();
    })

    it('test_startAnimation', 0, () => {
      const model = new OpenCloseAnimationViewModel() as object;
      model['startAnimation'](undefined);
      expect(model).not().assertNull();
    })

  })
}
