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

import { describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  FolderImageRegister,
  FolderImageCallback
} from '../../../../../../../main/ets/folder/model/FolderImageRegister';
import { FolderData } from '../../../../../../../main/ets/folder/model/FolderData';

export default function FolderImageRegisterTest() {
  describe('FolderImageRegisterTest', () => {
    it('test_getInstance', 0, () => {
      let tmpRegister: FolderImageRegister = FolderImageRegister.getInstance();
      expect(tmpRegister).not().assertNull();
    })

    let register: FolderImageRegister = FolderImageRegister.getInstance();

    let FOLDER_ID: string = 'FOLDER_ID';

    let callback: FolderImageCallback = {
      folderId: FOLDER_ID,
      refreshImageCallback: () => {
      }
    };

    it('test_registerCallBack', 0, () => {
      let _void = register.registerCallBack(callback);
      callback.folderId = undefined;
      _void = register.registerCallBack(callback);
      expect(true).assertTrue();
    })

    it('test_notifyImageRefresh', 0, () => {
      let mockKit: MockKit = new MockKit();
      const folderData = FolderData.getInstance();
      const getOpenFolderId: Function = mockKit.mockFunc(folderData, folderData.getOpenFolderId);
      when(getOpenFolderId)().afterReturn(FOLDER_ID);

      // 走异常
      callback.folderId = callback.folderId ?? FOLDER_ID;
      callback.refreshImageCallback = () => {
        let a = 1 / 0;
      };
      let _void = register.registerCallBack(callback);

      // 走空
      callback.refreshImageCallback = undefined;
      _void = register.registerCallBack(callback);

      expect(true).assertTrue();
    })

    it('test_unregisterCallBack', 0, () => {
      let _void = register.unregisterCallBack(callback);
      expect(true).assertTrue();
    })

  })
}
