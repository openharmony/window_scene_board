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

import PcFileAccess from '../../../../../../main/ets/common/controller/PcFileAccess';
import context from '@ohos.app.ability.common';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers
} from '@ohos/hypium'

export default function PcFileAccessTest() {
  describe('PcFileAccessTest', () => {
    let mocker: MockKit;
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      mocker = new MockKit();
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

    it('setDisplayIdTest', 0, () => {
      PcFileAccess.setDisplayId(0);
      expect((PcFileAccess as object)['displayId']).assertEqual(0);
    })

    it('renameNoCheckNoHistoryTest', 0, async() => {
      let mockFunc: Function = mocker.mockFunc(FileOperation, FileOperation.rename);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      await PcFileAccess.renameNoCheckNoHistory('srcUriTest', 'fileNameTest');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      await PcFileAccess.renameNoCheckNoHistory('srcUriTest', 'fileNameTest');
      mocker.clear(FileOperation);
      mocker.clearAll();
      expect((PcFileAccess as object)['displayId']).assertEqual(0);
    })

    it('copyFileTest', 0, async() => {
      let uris: string[] = ['file://fileUri1.txt','file://fileUri2.txt'];
      await PcFileAccess.copyFile(uris);
    });

    it('pasteFileTest', 0, async () => {
      const result: ESObject = await PcFileAccess.pasteFile('dest');
      if (!result) {
        expect(result).assertEqual(1);
      } else {
        expect(result).assertEqual(undefined);
      }
    });

    it('renameTest', 0, async() => {
      let uri: string = 'file://test/testFile.txt';
      let fileName: string = 'newFile.txt';
      await PcFileAccess.rename(uri, fileName);
    });

    it('renameNoCheckNoHistoryTest', 0, async() => {
      await PcFileAccess.renameNoCheckNoHistory('srcUriTest', 'fileNameTest');
    });

    it('stopListenFolderTest', 0, async () => {
      PcFileAccess.stopListenFolder('testUri');
    });

    it('getShowMenuItemTest', 0, async () => {
      let info: RightMenuInfo =
        new RightMenuInfo(new FileInfo(), ["fileTest1"], false, false, UnityStartMode.NORMAL, 0);
      let menuGroup: RightMenuClass[][] = [
        [{
          name: $r('app.string.compress_multi'),
          index: RcmItem.COMPRESS_MULTI,
          folder: true,
          file: true,
          mulFile: true,
          mulFolder: true,
          mulFileFolder: true
        },
          {
            name: $r('app.string.set_wallpaper'),
            index: RcmItem.SET_WALLPAPER,
            folder: false,
            file: true,
            mulFile: false,
            mulFolder: false,
            mulFileFolder: false
          },
          {
            name: $r('app.string.share'),
            index: RcmItem.SHARE,
            folder: true,
            file: true,
            mulFile: false,
            mulFolder: false,
            mulFileFolder: false
          },
        ]];
      const result = PcFileAccess.getShowMenuItem(info, menuGroup);
      expect(result).assertEqual(RightMenuViewUtils.getRightMenuItems(info, menuGroup));
    });

    it('handleMenuClickTest', 0, async () => {
      let rightMenuInfo: RightMenuInfo = new RightMenuInfo(new FileInfo(), [], false, false, UnityStartMode.NORMAL, 0);
      PcFileAccess.menuClick(1, rightMenuInfo)
    });

    it('setContextTest', 0, async () => {
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext
      PcFileAccess.setContext(context);
      expect((PcFileAccess as object)['context']).assertEqual(context);
    });

    it('getDesktopIsNullTest', 0, async () => {
      PcFileAccess.desktopPath = '';
      let mockFunc: Function = mocker.mockFunc(FilesQueryTaskUtil, FilesQueryTaskUtil.getDesktop);
      when(mockFunc)().afterReturn('mockDesktopPath');
      const result: ESObject = await PcFileAccess.getDesktop();
      expect(result).assertEqual('mockDesktopPath');
      mocker.ignoreMock(FilesQueryTaskUtil, FilesQueryTaskUtil.getDesktop);
    });

    it('getDesktopIsNullTest', 0, async () => {
      PcFileAccess.desktopPath = 'desktopPath';
      const result: ESObject = await PcFileAccess.getDesktop();
      expect(result).assertEqual('desktopPath');
    });

  })
}