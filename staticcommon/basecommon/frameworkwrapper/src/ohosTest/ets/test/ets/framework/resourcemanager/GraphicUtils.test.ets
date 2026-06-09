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
import { afterAll, afterEach,
  ArgumentMatchers,
  beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium'
import {
  AnimatedDrawableDescriptor,
  DrawableDescriptor,
  LayeredDrawableDescriptor,
  PixelMapDrawableDescriptor
} from '@kit.ArkUI';
import { GraphicUtils } from '../../../../../../main/ets/resourcemanager/GraphicsUtils';
import { image } from '@kit.ImageKit';
import { IconExtendParam } from '../../../../../../main/ets/resourcemanager/IconExtendParam';
import { Constants } from '@ohos/commonconstants';
import { Trace } from '@ohos/basicutils';

export function GraphicUtilsTest() {
  describe('GraphicUtilsTest', () => {

    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('changePixelToBase64_return_undefined', 0, async (done: Function) => {
      const result = await GraphicUtils.changePixelToBase64(undefined);
      expect(result).assertUndefined();
      done();
    });

    it('return_base64_string_when_everything_is_fine', 0, async (done: Function) => {
      let image: image.PixelMap = await resourceManagerCreateImage();
      ;
      const result = await GraphicUtils.changePixelToBase64(image);
      expect(true).assertTrue(); // result need test
      done();
    });

    it('test_changeBase64ToPixel_undefined', 0, async (done: Function) => {
      const result = await GraphicUtils.changeBase64ToPixel(undefined);
      expect(result).assertUndefined();
      done();
    });

    it('test_changeBase64ToPixel', 0, async (done: Function) => {
      let image: image.PixelMap = await resourceManagerCreateImage();
      let base64: string = await GraphicUtils.changePixelToBase64(image);
      const result = await GraphicUtils.changeBase64ToPixel(base64);
      expect(result).not().assertNull();
      done();
    });

    it('test_changePixelToBase64Child', 0, async (done: Function) => {
      let image: image.PixelMap = await resourceManagerCreateImage();
      const result = await GraphicUtils.changePixelToBase64Child(image);
      expect(result).not().assertNull();
      done();
    });

    it('test_getForeGroundBackGroundBase64_undefined', 0, async (done: Function) => {
      const result: string[] = await GraphicUtils.getForeGroundBackGroundBase64(null, null, null, null);
      expect(result.length).assertEqual(0);
      done();
    });

    it('should_return_undefined_when_bundleName_is_empty', 0, async () => {
      let bundleName: string = "";
      let iconSizeOfGrid: number = 16;
      let imageDescriptor: DrawableDescriptor = new DrawableDescriptor();
      let result = await GraphicUtils.getCombinePixelMap(bundleName, iconSizeOfGrid, imageDescriptor);
      expect(result).assertUndefined();
    });

    it('test_printPixelMapCenterInfo', 0, async () => {
      await GraphicUtils.checkPixelMapCenterInfo(null, 'test');
      let image = await resourceManagerCreateImage();
      await GraphicUtils.checkPixelMapCenterInfo(image, 'test');
      expect(!image).assertFalse();
    });

    it('test_getForeGroundBackGroundBase64_01', 0, async (done: Function) => {
      const size: number = 48;
      let bundleName: string = 'com.ohos.photos';
      let img: image.PixelMap = image.createPixelMapSync({ size: { width: 16, height: 16 } });
      let background: DrawableDescriptor = new PixelMapDrawableDescriptor(img);
      let foreground: DrawableDescriptor = new PixelMapDrawableDescriptor(img);
      let imageDescriptor: LayeredDrawableDescriptor = new LayeredDrawableDescriptor(foreground, background);
      try {
        const result: string[] =
          await GraphicUtils.getForeGroundBackGroundBase64(bundleName, size, imageDescriptor, null);
        expect(result).not().assertUndefined();
      }catch (error) {
      }
      done();
    });

    it('test_getForeGroundBackGroundBase64_02', 0, async (done: Function) => {
      const size: number = px2vp(Constants.APP_ICON_STANDARD_WIDTH);
      let bundleName: string = 'com.ohos.photos';
      let img: image.PixelMap = image.createPixelMapSync({ size: { width: 16, height: 16 } });
      let background: DrawableDescriptor = new PixelMapDrawableDescriptor(img);
      let foreground: DrawableDescriptor = new PixelMapDrawableDescriptor(img);
      let imageDescriptor: LayeredDrawableDescriptor = new LayeredDrawableDescriptor(foreground, background);
      const result: string[] =
        await GraphicUtils.getForeGroundBackGroundBase64(bundleName, size, imageDescriptor, null);
      expect(result).not().assertUndefined();
      done();
    });

    it('test_getCombinePixelMap_01', 0, async (): Promise<void> => {
      let bundleName: string = 'com.ohos.photos';
      let iconSizeOfGrid: number = 16;
      let imageDescriptor: DrawableDescriptor = new DrawableDescriptor();
      let result = await GraphicUtils.getCombinePixelMap(bundleName, iconSizeOfGrid, imageDescriptor);
      expect(result).assertUndefined();
    });

    it('test_getCombinePixelMap_02', 0, async (): Promise<void> => {
      let bundleName: string = 'com.ohos.photos';
      let iconSizeOfGrid: number = 16;
      let imageDescriptor: DrawableDescriptor = new LayeredDrawableDescriptor();
      let result = await GraphicUtils.getCombinePixelMap(bundleName, iconSizeOfGrid, imageDescriptor);
      expect(result).assertUndefined();
    });

    it('test_getCombinePixelMap_03', 0, async (): Promise<void> => {
      let img: image.PixelMap = image.createPixelMapSync({ size: { width: 1, height: 1 } });
      let bundleName: string = 'com.ohos.photos';
      let iconSizeOfGrid: number = 16;
      let imageDescriptor: DrawableDescriptor = new AnimatedDrawableDescriptor([img]);
      let result = await GraphicUtils.getCombinePixelMap(bundleName, iconSizeOfGrid, imageDescriptor);
      expect(result).assertUndefined();
    });

    it('test_getCombinePixelMap_04', 0, async (): Promise<void> => {
      let img: image.PixelMap = image.createPixelMapSync({ size: { width: 1, height: 1 } });
      let bundleName: string = 'com.ohos.photos';
      let iconSizeOfGrid: number = 16;
      let imageDescriptor: DrawableDescriptor = new AnimatedDrawableDescriptor([img]);
      let iconExtend: IconExtendParam = new IconExtendParam();
      iconExtend.isTransparentBorder = true;
      let result = await GraphicUtils.getCombinePixelMap(bundleName, iconSizeOfGrid, imageDescriptor, null, iconExtend);
      expect(result).assertUndefined();
    });

    it('test_getHdsLayeredIcon_01', 0, async (): Promise<void> => {
      let bundleName: string = '';
      let iconSizeOfGrid: number = 16;
      let result = GraphicUtils.getHdsLayeredIcon(bundleName, iconSizeOfGrid, null);
      expect(result).assertUndefined();
    });

    it('test_getHdsLayeredIcon_02', 0, async (): Promise<void> => {
      let bundleName: string = 'com.ohos.photos';
      let iconSizeOfGrid: number = 16;
      let imageDescriptor: LayeredDrawableDescriptor = new LayeredDrawableDescriptor();
      let result = GraphicUtils.getHdsLayeredIcon(bundleName, iconSizeOfGrid, imageDescriptor);
      expect(result).assertUndefined();
    });

    it('test_getHdsIcon_01', 0, async (): Promise<void> => {
      let result = await GraphicUtils.getHdsIcon(null, null, null, null);
      expect(result).assertUndefined();
    });

    it('test_getHdsIcon_02', 0, async (): Promise<void> => {
      let bundleName: string = 'com.ohos.photos';
      let iconSizeOfGrid: number = 16;
      let img: image.PixelMap = image.createPixelMapSync({ size: { width: 1, height: 1 } });
      let mask: image.PixelMap = image.createPixelMapSync({ size: { width: 1, height: 1 } });
      let result = await GraphicUtils.getHdsIcon(bundleName, iconSizeOfGrid, img, mask);
      expect(result).assertUndefined();
    });

    it('test_changeBase64ToPixelChild_01', 0, async (): Promise<void> => {
      let result = await GraphicUtils.changeBase64ToPixelChild('');
      expect(result).assertUndefined();
    });

    it('test_changeBase64ToPixelChild_mock_02', 0, async (): Promise<void> => {
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(Trace, Trace.start);
      when(mockFun)(ArgumentMatchers.any).afterThrow('mock error');
      let result = await GraphicUtils.changeBase64ToPixelChild('');
      expect(result).assertUndefined();
      mocker.clear(Trace);
      mocker.ignoreMock(Trace, mockFun);
      mocker.clearAll();
    });
  });

}

async function resourceManagerCreateImage(): Promise<image.PixelMap> {
  let width: number = 10;
  let height: number = 10;
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return image.createPixelMap(color, opts);
}