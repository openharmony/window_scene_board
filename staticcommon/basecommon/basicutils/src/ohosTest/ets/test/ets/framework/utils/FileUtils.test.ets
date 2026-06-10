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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import fileIo from '@ohos.file.fs';
import FileUtils from '../../../../../../main/ets/utils/FileUtils';

export function FileUtilTest() {
  describe('FileUtilTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('FileUtilTest_readStringFromFile', 0, (): void => {
      let filePath: string = 'version/etc/component_version.txt';
      expect(FileUtils.readStringFromFile(filePath)).assertInstanceOf('String');
    })

    it('FileUtilTest_createFolder', 0, (): void => {
      let pathExisted: string = 'version/etc';
      let path: string = '/data/local/tmp/new/'
      expect(FileUtils.createFolder(pathExisted)).assertTrue();
      expect(FileUtils.createFolder(path)).assertFalse();
    })

    it('FileUtilTest_readTextSync', 0, (): void => {
      let filePath: string = 'version/etc/component_version.txt';
      expect(FileUtils.readTextSync(filePath)).assertInstanceOf('String');
    })

    it('FileUtilTest_getUriFromPath', 0, (): void => {
      let filePath: string = 'version/etc/component_version.txt';
      expect(FileUtils.getUriFromPath(filePath)).assertInstanceOf('String');
    })

    it('FileUtilTest_deleteConfigFile', 0, (): void => {
      let filePath: string = 'version/etc/component_version.txt';
      let fileCopy: string = 'version/etc/component_version_copy.txt';
      let copy: boolean = FileUtils.copyFile(filePath, fileCopy);
      FileUtils.deleteConfigFile(fileCopy);
      expect(copy).assertFalse();
    })

    it('FileUtilTest_getFileList', 0, (): void => {
      let filePath: string = 'version/etc/';
      let list: string[] = FileUtils.getFileList(filePath);
      expect(list).not().assertNull();
    })

    it('FileUtilTest_openFile', 0, (): void => {
      let filePath: string = 'version/etc/component_version.txt';
      let file: fileIo.File | null = FileUtils.openFile(filePath);
      expect(file).not().assertNull();

      let isCloseSucc: boolean = FileUtils.closeFile(file);
      expect(isCloseSucc).not().assertNull();
    })

    it('FileUtilTest_getFileStream', 0, (): void => {
      let filePath: string = 'version/etc/component_version.txt';
      let stream: fileIo.Stream | null = FileUtils.getFileStream(filePath);
      expect(stream).assertNull();
    })
  })
}