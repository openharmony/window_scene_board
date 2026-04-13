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
import { AnimationBase } from '../../../../main/ets/animation/AnimationBase';
import curves from '@ohos.curves';
import { LiveVmInjector } from '../../../../main/ets/live/LiveVmInjector';
import { LiveNotification } from '../../../../main/ets/live/model/LiveNotification';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCardAnimation } from '../../../../main/ets/live/animation/LiveCardAnimation';
export default function LiveCardAnimationTest() {
  describe('removeCard_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_executeAnimation_when_removeCard_is_called', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called1', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters1', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called2', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters2', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called3', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters3', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called4', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters4', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called5', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters5', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called6', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters6', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called7', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters7', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called9', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters12', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called1', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters1', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called2', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters2', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called3', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters3', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called4', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters4', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called5', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters5', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called6', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters6', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called7', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters7', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called9', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters12', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters3', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called4', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters4', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called5', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters5', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called6', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters6', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called7', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters7', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called9', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters12', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called9', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters12', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters12', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters3', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called4', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters4', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called5', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters5', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called6', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters6', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called7', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters7', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called9', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters12', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called9', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters12', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters3', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called4', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters4', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called5', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters5', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called6', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters6', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called7', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters7', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called9', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters12', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters8', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called9', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called10', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_when_removeCard_is_called11', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });

    it('should_call_executeAnimation_with_correct_parameters12', 0, async () => {
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecardanimation: LiveCardAnimation = new LiveCardAnimation(vmInjector);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecardanimation, livecardanimation.executeAnimation);
      let event: () => void = () => {
      };
      let expectedCurve: curves.Curve = curves.Friction;
      let expectedDuration: number = 300;
      let expectedEventName: string = 'removeCard';

      when(mockfunc)([ArgumentMatchers.anyObj], [ArgumentMatchers.anyString], [ArgumentMatchers.anyNumber])
        .afterReturn(null);

      await livecardanimation.removeCard(event);

      mocker.ignoreMock(livecardanimation, livecardanimation.executeAnimation);
    });
  });
}