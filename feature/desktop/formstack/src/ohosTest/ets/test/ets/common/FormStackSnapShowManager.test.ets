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

import { image } from '@kit.ImageKit';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { CheckEmptyUtils } from '@ohos/basicutils';
import {
  FormStackSnapShowManager,
  formStackSnapShowManager } from '../../../../../main/ets/common/FormStackSnapShowManager';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';

export function FormStackSnapShowManagerTest() {
  describe('FormStackSnapShowManagerTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getInstance', 0, () => {
      try {
        expect(formStackSnapShowManager == undefined).assertFalse();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('notifyShowSnapImgMsg', 0, () => {
      try {
        formStackSnapShowManager.notifyShowSnapImgMsg(false, '', 1);
        formStackSnapShowManager.notifyShowSnapImgMsg(true, '', 1);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('createCoverImgPixelMap', 0, () => {
      try {
        formStackSnapShowManager.createCoverImgPixelMap({} as image.PixelMap, '123');
        formStackSnapShowManager.createCoverImgPixelMap({} as image.PixelMap, '');
        expect(formStackSnapShowManager.dropItemKey).assertEqual('');
        formStackSnapShowManager.createCoverImgPixelMap({} as image.PixelMap, '123');
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('createCoverImgPixelMap_01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let dropImageFun: Function = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidImage);
        when(dropImageFun)(ArgumentMatchers.any).afterReturn(true);
        formStackSnapShowManager.createCoverImgPixelMap({} as image.PixelMap, '1');
        expect(true).assertEqual(true);
        mocker.clear(FormStackUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('createCoverImgPixelMap_02', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let dropImageFun: Function = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidImage);
        when(dropImageFun)(ArgumentMatchers.any).afterReturn(false);
        formStackSnapShowManager.createCoverImgPixelMap({} as image.PixelMap, '1');
        expect(true).assertEqual(true);
        mocker.clear(FormStackUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('createCoverImgPixelMap_03', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let CheckEmptyUtilsFun: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(CheckEmptyUtilsFun)(ArgumentMatchers.any).afterReturn(true);
        formStackSnapShowManager.createCoverImgPixelMap({} as image.PixelMap, '');
        expect(true).assertEqual(true);
        mocker.clear(CheckEmptyUtils);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('createCoverImgPixelMap_04', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let CheckEmptyUtilsFun: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(CheckEmptyUtilsFun)(ArgumentMatchers.any).afterReturn(false);
        formStackSnapShowManager.createCoverImgPixelMap({} as image.PixelMap, '');
        expect(true).assertEqual(true);
        mocker.clear(CheckEmptyUtils);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('releaseCoverImage', 0, () => {
      try {
        formStackSnapShowManager.releaseCoverImage();
        expect(formStackSnapShowManager.dropItemKey).assertEqual('');
        formStackSnapShowManager.dropItemKey = '123';
        formStackSnapShowManager.releaseCoverImage();
        expect(formStackSnapShowManager.coverImagePixel).assertUndefined();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('releaseCoverImage_01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let CheckEmptyUtilsFun: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(CheckEmptyUtilsFun)(ArgumentMatchers.any).afterReturn(false);
        formStackSnapShowManager.releaseCoverImage();
        expect(true).assertEqual(true);
        mocker.clear(CheckEmptyUtils);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('releaseCoverImage_02', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let CheckEmptyUtilsFun: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(CheckEmptyUtilsFun)(ArgumentMatchers.any).afterReturn(true);
        formStackSnapShowManager.releaseCoverImage();
        expect(true).assertEqual(true);
        mocker.clear(CheckEmptyUtils);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getInstance_test01', 0, () => {
      try {
        FormStackSnapShowManager.mInstance = new FormStackSnapShowManager();
        FormStackSnapShowManager.getInstance();
        expect(FormStackSnapShowManager).not().assertUndefined();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('notifyShowSnapImgMsg_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        formStackSnapShowManager.notifyShowSnapImgMsg(true, 'a', 1);
        expect(formStackSnapShowManager).not().assertUndefined();
        mocker.clear(AppStorage);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('cancelSnapViewShow_test01', 0, () => {
      try {
        (formStackSnapShowManager as object)['isSnapViewShow'] = true;
        formStackSnapShowManager.cancelSnapViewShow();
        expect(formStackSnapShowManager).not().assertUndefined();

        (formStackSnapShowManager as object)['isSnapViewShow'] = false;
        formStackSnapShowManager.cancelSnapViewShow();
        expect(formStackSnapShowManager).not().assertUndefined();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  });
}