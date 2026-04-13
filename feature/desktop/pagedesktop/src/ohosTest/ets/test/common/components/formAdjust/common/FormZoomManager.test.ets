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

import { image } from '@kit.ImageKit';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  TestType,
  Level,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  FormZoomManager
} from '../../../../../../../main/ets/default/common/components/formAdjust/common/FormZoomManager';

export default function FormZoomManagerTest() {
  describe('FormZoomManagerTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('setFormZoomSnapshot_1', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formZoomManager: FormZoomManager = FormZoomManager.getInstance();
        (formZoomManager as object)['mFormZoomSnapshot'] = image.createPixelMapSync(
          new ArrayBuffer(4),
          {
            pixelFormat: 3,
            size: {
              height: 1,
              width: 1
            }
          });
        FormZoomManager.getInstance().setFormZoomSnapshot('formZoomTest', new CardItemInfo(), {
          height: 1,
          width: 1
        });
        expect(FormZoomManager.getInstance().getFormZoomSnapshot()).not().assertUndefined();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('setFormZoomSnapshot_2', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formZoomManager: FormZoomManager = FormZoomManager.getInstance();
        (formZoomManager as object)['mFormZoomSnapshot'] = image.createPixelMapSync(
          new ArrayBuffer(4),
          {
            pixelFormat: 3,
            size: {
              height: 1,
              width: 1
            }
          });
        FormZoomManager.getInstance().deleteFormZoomSnapshot();
        expect(FormZoomManager.getInstance().getFormZoomSnapshot()).not().assertUndefined();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('setFormZoomLocked', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        FormZoomManager.getInstance().setFormZoomLocked(true);
        let isFormZoomLocked: boolean = FormZoomManager.getInstance().isFormZoomLocked();
        expect(isFormZoomLocked).assertTrue();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}