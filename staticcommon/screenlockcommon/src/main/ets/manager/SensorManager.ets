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

import sensor from '@ohos.sensor';
import type BusinessError from '@ohos.base';
import type { Callback } from '@ohos.base';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';

const TAG: string = 'SensorManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
class SensorManager {

    public registerOrientationListener(callback: Callback<sensor.OrientationResponse>, interval?: number): boolean {
        try {
            sensor.on(sensor.SensorId.ORIENTATION, callback, { interval: interval ? interval : 1000000 });
            return true;
        } catch (error) {
            let e: BusinessError.BusinessError = error as BusinessError.BusinessError;
            log.showError(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
            return false;
        }
    }

    public unRegisterOrientationListener(): boolean {
        try {
            sensor.off(sensor.SensorId.ORIENTATION);
            return true;
        } catch (error) {
            let e: BusinessError.BusinessError = error as BusinessError.BusinessError;
            log.showError(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
            return false;
        }
    }

    public checkIsInverted(): Promise<boolean> {
        return new Promise((resolve) => {
            try {
                sensor.once(sensor.SensorId.ORIENTATION, (data: sensor.OrientationResponse) => {
                    log.showInfo(`Succeeded in the device rotating at an angle around the x(${data.beta}), y(${data.gamma}), z(${data.alpha}) axis.`);
                    const isInverted: boolean = (data.beta >= 50 && data.beta <= 90);
                    log.showInfo(`isInverted: ${isInverted}`);
                    resolve(isInverted);
                });
            } catch (error) {
                let e: BusinessError.BusinessError = error as BusinessError.BusinessError;
                log.showError(`Failed to invoke once. Code: ${e.code}, message: ${e.message}`);
                resolve(false);
            }
        });

    }
}

export let sensorManager = SingletonHelper.getInstance(SensorManager, TAG);