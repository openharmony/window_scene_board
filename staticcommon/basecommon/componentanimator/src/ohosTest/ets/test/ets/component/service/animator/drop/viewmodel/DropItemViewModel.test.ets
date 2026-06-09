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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import {
  AnimationViewData
} from '../../../../../../../../../main/ets/service/animator/common/viewmodel/AnimationViewData'
import { SnapshotListener, SnapshotType } from '@ohos/componenthelper'
import { image } from '@kit.ImageKit'
import {
  DropItemViewModel
} from '../../../../../../../../../main/ets/service/animator/drop/viewmodel/DropItemViewModel'
import {
  DropAnimationExEvent,
  DropAnimationExParam,
  DropAnimationParam
} from '../../../../../../../../../main/ets/service/animator/drop/bean/DropAnimationParam'
import { DropAnimationDestination } from '../../../../../../../../../main/ets/TsIndex';
import { CustomAnimation } from '../../../../../../../../../main/ets/service/animator/common/utils/FrameAnimationUtil';
import { FrameAnimationParam } from '../../../../../../../../../../Index'
import curves from '@ohos.curves';
import {
  CustomAnimationItem,
  CustomAnimationParam
} from '../../../../../../../../../main/ets/service/animator/common/utils/FrameAnimationUtil'

export default function DropItemViewModelTest() {
  describe('DropItemViewModelTest', () => {
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
    it('DropItemViewModel_loadSnapshot_test01', 0, () => {
      let snapshotListener1: SnapshotListener = {
        onSnapshotFinish(image: image.PixelMap, type: SnapshotType, key: string) {
        },
        onSnapshotRelease(type: SnapshotType, key: string) {
        }
      }
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      (animationViewData as object)['snapshotListener'] = snapshotListener1;
      dropItemViewModel.loadSnapshot();
      expect(dropItemViewModel).not().assertUndefined();
    })

    it('DropItemViewModel_applyAnimationChangeToViewData_test01', 0, () => {
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      animationViewData.opacity = 1;
      animationViewData.translateX = 1;
      animationViewData.translateY = 1;
      animationViewData.width = 1;
      animationViewData.height = 1;
      animationViewData.radius = 1;
      animationViewData.scaleX = 1;
      animationViewData.scaleY = 1;
      animationViewData.rotate = {
        angle: 1
      };
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      let dropAnimationExEvent: DropAnimationExEvent = new DropAnimationExEvent();
      (dropItemViewModel as object)['applyAnimationChangeToViewData'](dropAnimationExEvent);
      expect(dropItemViewModel).not().assertUndefined();
    })

    it('DropItemViewModel_applyAnimationChangeToViewData_test02', 0, () => {
      let dropAnimationExEvent: DropAnimationExEvent = new DropAnimationExEvent();
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      dropAnimationExEvent.endOpacity = 1;
      dropAnimationExEvent.endX = 1;
      dropAnimationExEvent.endY = 1;
      dropAnimationExEvent.endWidth = 1;
      dropAnimationExEvent.endHeight = 1;
      dropAnimationExEvent.endRadius = 1;
      dropAnimationExEvent.endScaleX = 1;
      dropAnimationExEvent.endScaleY = 1;
      dropAnimationExEvent.endRotate = {
        angle: 1
      };
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      (dropItemViewModel as object)['applyAnimationChangeToViewData'](dropAnimationExEvent);
      expect(dropItemViewModel).not().assertUndefined();
    })

    it('DropItemViewModel_processDropAnimationParam_test01', 0, () => {
      let dropAnimationParam: DropAnimationParam = new DropAnimationParam('1', 1, 1, 1, 1);
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      dropAnimationParam.endWidth = 0;
      dropAnimationParam.endHeight = 0;
      dropAnimationParam.endRadius = 0;
      dropAnimationParam.endScaleX = 0;
      dropAnimationParam.endScaleY = 0;
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      (dropItemViewModel as object)['processDropAnimationParam'](dropAnimationParam);
      expect(dropItemViewModel).not().assertUndefined();
    })

    it('DropItemViewModel_processDropAnimationParam_test02', 0, () => {
      let dropAnimationParam: DropAnimationParam = new DropAnimationParam('1', 1, 1, 1, 1);
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      dropAnimationParam.endWidth = 1;
      dropAnimationParam.endHeight = 1;
      dropAnimationParam.endRadius = 1;
      dropAnimationParam.endScaleX = 1;
      dropAnimationParam.endScaleY = 1;
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      (dropItemViewModel as object)['processDropAnimationParam'](dropAnimationParam);
      expect(dropItemViewModel).not().assertUndefined();
    })

    it('DropItemViewModel_onAnimationFinish_test01', 0, () => {
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      animationViewData.isShow = false;
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      (dropItemViewModel as object)['onAnimationFinish'](true, true, 0);
      expect(dropItemViewModel).not().assertUndefined();
    })

    it('DropItemViewModel_onAnimationFinish_test02', 0, () => {
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      animationViewData.isShow = true;
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      (dropItemViewModel as object)['onAnimationFinish'](true, true, 0);
      expect(dropItemViewModel).not().assertUndefined();
    })

    it('DropItemViewModel_illegalsAnimate_test01', 0, () => {
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      (dropItemViewModel as object)['onAnimationFinish'](true, true, 0);
      expect(dropItemViewModel).not().assertUndefined();
    })

    it('DropItemViewModel_loadSnapshot_test001', 0, async (done: Function) => {
      let snapshotListener1: SnapshotListener = {
        onSnapshotFinish(image: image.PixelMap, type: SnapshotType, key: string) {
        },
        onSnapshotRelease(type: SnapshotType, key: string) {
        }
      }
      let imageMap1: image.PixelMap = await createImage(2, 3);
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      animationViewData.pixmap = imageMap1;
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      (animationViewData as object)['snapshotListener'] = snapshotListener1;
      dropItemViewModel.loadSnapshot();
      expect(dropItemViewModel).not().assertUndefined();
      (dropItemViewModel as object)['dropSnapshot'] = imageMap1;
      dropItemViewModel.loadSnapshot();
      expect(dropItemViewModel).not().assertUndefined();
      done();
    })

    it('DropItemViewModel_startAnimation_test001', 0, async (done: Function) => {
      let param: DropAnimationParam = new DropAnimationParam('1', 0, 0, 0, 0);
      let target: DropAnimationDestination = DropAnimationDestination.DESKTOP;
      let imageMap1: image.PixelMap = await createImage(2, 3);
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      animationViewData.pixmap = imageMap1;
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      dropItemViewModel.startAnimation(param, target, 0);
      expect(dropItemViewModel).not().assertUndefined();
      (dropItemViewModel as object)['dropSnapshot'] = imageMap1;
      dropItemViewModel.startAnimation(param, target, 0);
      expect(dropItemViewModel).not().assertUndefined();
      done();
    })

    it('DropItemViewModel_updateDropItemViewData_test001', 0, async (done: Function) => {
      let param: DropAnimationParam = new DropAnimationParam('1', 0, 0, 0, 0);
      let target: DropAnimationDestination = DropAnimationDestination.DESKTOP;
      let imageMap1: image.PixelMap = await createImage(2, 3);
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      animationViewData.pixmap = imageMap1;
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      (dropItemViewModel as object)['dropSnapshot'] = imageMap1;
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(animationViewData, animationViewData.pixmap.getPixelBytesNumber);
      when(mockFunc)().afterReturn(undefined);
      dropItemViewModel.updateDropItemViewData(param, target);
      expect(dropItemViewModel).not().assertUndefined();
      mock.ignoreMock(animationViewData, animationViewData.pixmap.getPixelBytesNumber);
      done();
    })

    it('DropItemViewModel_startAnimationAsync_test001', 0, async (done: Function) => {
      let param: DropAnimationParam = new DropAnimationParam('1', 0, 0, 0, 0);
      let target: DropAnimationDestination = DropAnimationDestination.DESKTOP;
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      await dropItemViewModel.startAnimationAsync(param, target, true, 0);
      expect(dropItemViewModel).not().assertUndefined();
      done();
    })

    it('DropItemViewModel_startAnimationAsync_test002', 0, async (done: Function) => {
      let param: DropAnimationParam = new DropAnimationParam('1', 0, 0, 0, 0);
      let param1: DropAnimationExParam = new DropAnimationExParam('1', 0, 0, []);
      let target: DropAnimationDestination = DropAnimationDestination.DESKTOP;
      let imageMap1: image.PixelMap = await createImage(2, 3);
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      animationViewData.pixmap = imageMap1;
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      (dropItemViewModel as object)['dropSnapshot'] = imageMap1;
      await dropItemViewModel.startAnimationAsync(param, target, true, 0);
      expect(dropItemViewModel).not().assertUndefined();
      await dropItemViewModel.startAnimationAsync(param1, target, true, 0);
      expect(dropItemViewModel).not().assertUndefined();
      done();
    })

    it('DropItemViewModel_startFrameAnimation_test001', 0, async (done: Function) => {
      let param: FrameAnimationParam = {
        animationId: '',
        id: '',
        delay: 0,
        duration: 0,
        endDelay: 0,
        curves: curves.initCurve(undefined),
        begins: [],
        targets: [],
        onRender: (viewData: AnimationViewData, currentVal: number[]): void => {
          throw new Error('Function not implemented.')
        }
      }
      let params: FrameAnimationParam[] = [param];
      let target: DropAnimationDestination = DropAnimationDestination.DESKTOP;
      let imageMap1: image.PixelMap = await createImage(2, 3);
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      await dropItemViewModel.startFrameAnimation(target, params, true);
      expect(dropItemViewModel).not().assertUndefined();
      (dropItemViewModel as object)['dropSnapshot'] = imageMap1;
      await dropItemViewModel.startFrameAnimation(target, params, true);
      expect(dropItemViewModel).not().assertUndefined();
      done();
    })

    it('DropItemViewModel_updateFrameAnimation_test001', 0, async (done: Function) => {
      let customAnimation: CustomAnimation = new CustomAnimation();
      let animationList1: Map<string, CustomAnimationItem> = new Map();
      let customAnimationParam: CustomAnimationParam = {
        id: '',
        delay: 0,
        duration: 0,
        endDelay: 0,
        curves: curves.initCurve(undefined),
        begins: [],
        targets: [],
        onRender: (currentProgress: number[]): void => {
          throw new Error('Function not implemented.')
        },
        onFinish: (isCancel: boolean): void => {
          throw new Error('Function not implemented.')
        }
      }
      let customAnimationItem: CustomAnimationItem = new CustomAnimationItem(customAnimationParam);
      let param: FrameAnimationParam = {
        animationId: '',
        id: '',
        delay: 0,
        duration: 0,
        endDelay: 0,
        curves: curves.initCurve(undefined),
        begins: [],
        targets: [],
        onRender: (viewData: AnimationViewData, currentVal: number[]): void => {
          throw new Error('Function not implemented.')
        }
      }
      let params: FrameAnimationParam[] = [param];
      let target: DropAnimationDestination = DropAnimationDestination.DESKTOP;
      let imageMap1: image.PixelMap = await createImage(2, 3);
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      await dropItemViewModel.updateFrameAnimation(params);
      expect(dropItemViewModel).not().assertUndefined();
      (dropItemViewModel as object)['dropSnapshot'] = imageMap1;
      (customAnimation as object)['animationList'] = animationList1;
      (dropItemViewModel as object)['frameAnimation'] = customAnimation;
      await dropItemViewModel.updateFrameAnimation(params);
      expect(dropItemViewModel).not().assertUndefined();
      animationList1.set('1', customAnimationItem);
      (customAnimation as object)['animationList'] = animationList1;
      (dropItemViewModel as object)['frameAnimation'] = customAnimation;
      await dropItemViewModel.updateFrameAnimation(params);
      expect(dropItemViewModel).not().assertUndefined();
      done();
    })

    it('DropItemViewModel_onAnimationFinish_test001', 0, () => {
      let animationViewData: AnimationViewData = new AnimationViewData('1');
      animationViewData.isShow = true;
      let dropItemViewModel: DropItemViewModel = new DropItemViewModel(animationViewData);
      (dropItemViewModel as object)['onAnimationFinish'](true, false, 1);
      expect(dropItemViewModel).not().assertUndefined();
    })

  })
}

async function createImage(width: number, height: number): Promise<image.PixelMap> {
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return image.createPixelMap(color, opts);
}