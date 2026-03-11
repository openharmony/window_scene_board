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
import { OpenCoverAnimationController, SCBScreenPowerEvent, SCBScreenPowerEventType, SCBScreenPowerEventStatus, SCBScreenPowerStatusChangeReason } from 'path_to_your_module';

const TAG = 'OpenCoverAnimationControllerTest';

export default function OpenCoverAnimationControllerTest(){
    describe('OpenCoverAnimationController', () => {
        let controller: OpenCoverAnimationController;

        beforeEach(() => {
            controller = OpenCoverAnimationController.getInstance();
        });

        it('should initialize instance', () => {
            expect(controller).toBeInstanceOf(OpenCoverAnimationController);
        });

        it('should get display on delay time', () => {
            const delayTime = OpenCoverAnimationController.getDisplayOnDelayTime();
            expect(typeof delayTime).toBe('number');
        });

        it('should check if KLV device', () => {
            const isKLV = OpenCoverAnimationController.isKLV();
            expect(typeof isKLV).toBe('boolean');
        });

        it('should handle power events', () => {
            const powerEvent: SCBScreenPowerEvent = {
                eventType: SCBScreenPowerEventType.WAKE_UP,
                eventStatus: SCBScreenPowerEventStatus.BEGIN,
                changeReason: SCBScreenPowerStatusChangeReason.POWER_CHANGE_REASON_SWITCH
            };
            controller.handlePowerEvents(powerEvent);
            expect(controller.isDisplayOnForOpeningCover).toBe(true);
        });

        it('should run init param callbacks', () => {
            let callbackCalled = false;
            controller.registerInitParamCallback('testCallback', () => {
                callbackCalled = true;
            });
            controller.runInitParamCallbacks();
            expect(callbackCalled).toBe(true);
        });

        it('should run animation callbacks', () => {
            let callbackCalled = false;
            controller.registerAnimationCallback('testAnimation', () => {
                callbackCalled = true;
            });
            controller.runAnimationCallbacks();
            expect(callbackCalled).toBe(true);
        });

        it('should unregister callback', () => {
            controller.registerInitParamCallback('testCallback', () => {});
            controller.registerAnimationCallback('testAnimation', () => {});
            controller.unregisterCallback('testCallback');
            controller.unregisterCallback('testAnimation');
            expect(controller.initParamMap.has('testCallback')).toBe(false);
            expect(controller.animationParamMap.has('testAnimation')).toBe(false);
        });

        it('should handle exception', () => {
            controller.isDisplayOnForOpeningCover = true;
            controller.handleException();
            expect(controller.isDisplayOnForOpeningCover).toBe(false);
        });

        it('should get animation param', () => {
            const animationParam = controller.getAnimationParam(OpenCoverAnimationController.DATE_VIEW_ANIMATION);
            expect(animationParam).not.toBeNull();
        });

        it('should get animation param for others', () => {
            const animationParam = controller.getAnimationParamOthers(OpenCoverAnimationController.LIGHT_VIEW_ANIMATION);
            expect(animationParam).not.toBeNull();
        });

        it('should destroy instance', () => {
            controller.destroy();
            expect(controller.handlePowerEventListener).toBeUndefined();
        });
    });
}
