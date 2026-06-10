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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import {
  dragSnapshotHelper,
  SnapshotListener,
  SnapshotType,
} from '../../../../../../main/ets/utils/DragSnapshotHelper';
import { image } from '@kit.ImageKit';

/**
 * 拖拽截图工具类 DT测试套
 */
export function DragSnapshotHelperTest() {
  describe('DragSnapshotHelperTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('DragSnapshotHelper_not_null', Level.LEVEL0, (): void => {
      expect(dragSnapshotHelper).not().assertNull();
    })

    it('DragSnapshotHelper_simple_snapshot_001', Level.LEVEL0, (): void => {
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, null)).assertUndefined();
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, '01')).assertUndefined();
    })

    it('DragSnapshotHelper_simple_snapshot_002', Level.LEVEL0, async (done: Function) => {
      let dropImg = await dragCreateImage();
      dragSnapshotHelper.setSnapshot(dropImg, SnapshotType.DROP, '02');

      let dragImg = await dragCreateImage();
      dragSnapshotHelper.setSnapshot(dragImg, SnapshotType.DRAG, '002');

      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, '002')).assertEqual(dragImg);
      done();
    })

    it('DragSnapshotHelper_simple_snapshot_003', Level.LEVEL0, async (done: Function) => {
      let dropImg = await dragCreateImage();
      dragSnapshotHelper.setSnapshot(dropImg, SnapshotType.DRAG, '03');

      let dragImg = await dragCreateImage();
      dragSnapshotHelper.setSnapshot(dragImg, SnapshotType.DROP, '003');

      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DROP, '003')).assertEqual(dragImg);
      done();
    })

    it('DragSnapshotHelper_simple_snapshot_004', Level.LEVEL0, async (done: Function) => {
      let dropImg = await dragCreateImage();
      dragSnapshotHelper.setSnapshot(dropImg, SnapshotType.BOTH, '03');

      let dragImg = await dragCreateImage();
      dragSnapshotHelper.setSnapshot(dragImg, SnapshotType.BOTH, '003');

      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DROP, '003')).assertEqual(dragImg);
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, '003')).assertEqual(dragImg);

      /* 清理一下 */
      dragSnapshotHelper.setSnapshot(null, SnapshotType.BOTH, '');
      done();
    })

    it('DragSnapshotHelper_simple_snapshotFromId_001', Level.LEVEL0, (): void => {
      let count = 0;
      dragSnapshotHelper.snapshotFromId(null, SnapshotType.DRAG, null, null);

      AppStorage.set<boolean>('isDrag', true);
      dragSnapshotHelper.snapshotFromId(null, SnapshotType.DRAG, null, (res) => {
        count = 1;
      })
      AppStorage.set<boolean>('isDrag', false);
      expect(count).assertEqual(0);
    })

    it('DragSnapshotHelper_simple_snapshotFromId_002', Level.LEVEL0, (): void => {
      let count = 0;

      AppStorage.set<boolean>('isDrag', false);
      dragSnapshotHelper.snapshotFromId('', SnapshotType.DRAG, 'null', (res) => {
        count = 1;
      })
      expect(count).assertEqual(0);
    })

    it('DragSnapshotHelper_simple_snapshotFromId_003', Level.LEVEL0, (): void => {
      let count = 0;

      AppStorage.set<boolean>('isDrag', true);
      dragSnapshotHelper.snapshotFromId('', SnapshotType.DRAG, 'null', (res) => {
        count = 1;
      })
      AppStorage.set<boolean>('isDrag', false);
      expect(count).assertEqual(0);
    })

    it('DragSnapshotHelper_simple_snapshotFromId_004', Level.LEVEL0, (): void => {
      let count = 0;

      dragSnapshotHelper.snapshotFromId(null, SnapshotType.DRAG, null, (res) => {
        count = 1;
      })
      expect(count).assertEqual(0);
    })

    it('DragSnapshotHelper_simple_snapshotFromIdSync_001', Level.LEVEL0, (): void => {
      let count = 0;

      dragSnapshotHelper.snapshotFromIdSync(null, SnapshotType.DRAG, null, (res) => {
        count = 1;
      })
      expect(count).assertEqual(0);
    })

    it('DragSnapshotHelper_simple_snapshotFromBuilder_001', Level.LEVEL0, (): void => {
      let count = 0;

      dragSnapshotHelper.snapshotFromBuilder(null, SnapshotType.DRAG, null, null);

      AppStorage.set<boolean>('isDrag', true);
      dragSnapshotHelper.snapshotFromBuilder(null, SnapshotType.DRAG, null, (res) => {
        count = 1;
      })
      AppStorage.set<boolean>('isDrag', false);
      expect(count).assertEqual(0);
    })

    it('DragSnapshotHelper_simple_snapshotFromBuilder_002', Level.LEVEL0, (): void => {
      let count = 0;

      AppStorage.set<boolean>('isDrag', false);
      dragSnapshotHelper.snapshotFromBuilder(null, SnapshotType.DRAG, 'null', (res) => {
        count = 1;
      })
      expect(count).assertEqual(0);
    })

    it('DragSnapshotHelper_releaseSnapshot', Level.LEVEL0, async (done: Function) => {
      let dragImg = await dragCreateImage();
      dragSnapshotHelper.setSnapshot(dragImg, SnapshotType.BOTH, '1');
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DROP, '1')).assertEqual(dragImg);
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, '1')).assertEqual(dragImg);
      dragSnapshotHelper.releaseSnapshot(SnapshotType.DRAG, '');
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, '1')).assertEqual(dragImg);
      dragSnapshotHelper.releaseSnapshot(SnapshotType.DRAG, '1');
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, '1')).assertUndefined();
      dragSnapshotHelper.releaseSnapshot(SnapshotType.DROP, '1');
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DROP, '1')).assertUndefined();

      dragImg = await dragCreateImage();
      dragSnapshotHelper.setSnapshot(dragImg, SnapshotType.BOTH, '1');
      dragSnapshotHelper.releaseSnapshot(SnapshotType.BOTH, '1');
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, '1')).assertUndefined();
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DROP, '1')).assertUndefined();
      done();
    })

    it('DragSnapshotHelper_use_invalid_type', Level.LEVEL0, async (done: Function) => {
      let dragImg = await dragCreateImage();
      let invalidType: number = 3;
      let key: string = '1';
      dragSnapshotHelper.setSnapshot(dragImg, invalidType, key);
      expect(dragSnapshotHelper.getSnapshot(invalidType, key)).assertUndefined();
      done();
    })

    it('DragSnapshotHelper_setSnapshot_with_same_key', Level.LEVEL0, async (done: Function) => {
      let dragImg = await dragCreateImage();
      let key: string = '1';
      dragSnapshotHelper.setSnapshot(null, SnapshotType.DRAG, key);
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, key)).assertNull();
      dragSnapshotHelper.setSnapshot(dragImg, SnapshotType.DRAG, key);
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, key)).assertEqual(dragImg);
      dragSnapshotHelper.setSnapshot(dragImg, SnapshotType.DROP, key);
      expect(dragSnapshotHelper.getSnapshot(SnapshotType.DROP, key)).assertEqual(dragImg);
      done();
    })

    it('DragSnapshotHelper_registerSnapshotListener', Level.LEVEL0, async (done: Function) => {
      let dragImg = await dragCreateImage();
      let key: string = '1';
      let listenImg: image.PixelMap | undefined = undefined;
      let listener: SnapshotListener = {
        onSnapshotFinish: (image: image.PixelMap, type: SnapshotType, key: string) => {
          listenImg = image;
        }
      };
      dragSnapshotHelper.registerSnapshotListener(listener, key);
      dragSnapshotHelper.snapshot(async () => dragImg, SnapshotType.DRAG, key, (value: image.PixelMap) => {
        expect(value).assertEqual(dragImg);
        expect(listenImg).assertEqual(dragImg);
        dragSnapshotHelper.unregisterSnapshotListener(listener, key);
        done();
      });
    })

    it('DragSnapshotHelper_getListenerCount', Level.LEVEL0, (): void => {
      let key1: string = '1';
      let key2: string = '2';
      let listener1: SnapshotListener = { onSnapshotFinish: () => {} };
      let listener2: SnapshotListener = { onSnapshotFinish: () => {} };
      expect(dragSnapshotHelper.getListenerCount(key1)).assertInstanceOf('Number');
      dragSnapshotHelper.registerSnapshotListener(listener1, key1);
      expect(dragSnapshotHelper.getListenerCount(key1)).assertInstanceOf('Number');
      dragSnapshotHelper.registerSnapshotListener(listener2, key1);
      expect(dragSnapshotHelper.getListenerCount(key1)).assertInstanceOf('Number');
      dragSnapshotHelper.unregisterSnapshotListener(listener1, key2);
      expect(dragSnapshotHelper.getListenerCount(key1)).assertInstanceOf('Number');
      dragSnapshotHelper.unregisterSnapshotListener(listener1, key1);
      expect(dragSnapshotHelper.getListenerCount(key1)).assertInstanceOf('Number');
      dragSnapshotHelper.unregisterSnapshotListener(listener2, key1);
      expect(dragSnapshotHelper.getListenerCount(key1)).assertInstanceOf('Number');
    })

    it('DragSnapshotHelper_clearListener', Level.LEVEL0, (): void => {
      let key1: string = '1';
      let key2: string = '2';
      let listener1: SnapshotListener = { onSnapshotFinish: () => {} };
      let listener2: SnapshotListener = { onSnapshotFinish: () => {} };
      dragSnapshotHelper.registerSnapshotListener(listener1, key1);
      dragSnapshotHelper.registerSnapshotListener(listener2, key1);
      expect(dragSnapshotHelper.getListenerCount(key1)).not().assertEqual(0);
      dragSnapshotHelper.clearListener(key2);
      expect(dragSnapshotHelper.getListenerCount(key1)).not().assertEqual(0);
      dragSnapshotHelper.clearListener();
      expect(dragSnapshotHelper.getListenerCount(key1)).assertEqual(0);
    })

    it('DragSnapshotHelper_setEnableWrite', Level.LEVEL0, (): void => {
      dragSnapshotHelper.setEnableWrite(null);
      expect(dragSnapshotHelper.isEnableWrite()).assertFalse();
      dragSnapshotHelper.setEnableWrite([]);
      expect(dragSnapshotHelper.isEnableWrite()).assertFalse();
      dragSnapshotHelper.setEnableWrite(['invalid']);
      expect(dragSnapshotHelper.isEnableWrite()).assertFalse();
      dragSnapshotHelper.setEnableWrite(['1']);
      expect(dragSnapshotHelper.isEnableWrite()).assertTrue();
    })
  })
}

async function dragCreateImage(): Promise<image.PixelMap> {
  let width: number = 10;
  let height: number = 10;
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: height, width: width } };
  return image.createPixelMap(color, opts);
}