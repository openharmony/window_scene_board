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

import { Serializable } from './Serializable';

type AnyType = string | boolean | number | bigint | null | object | undefined;

/**
 * 构造函数类型
 */
export type ClassCtor<T extends Serializable> = (...args: AnyType[]) => T

function createClazz<T extends Serializable>(Ctor: ClassCtor<T>, ...args: AnyType[]): T {
    return Ctor(...args);
}

/**
 * json序列/反序列化
 *
 * @since 2022-09-27
 */
export class JsonUtils {
    /**
     * 序列化对象到json字串
     *
     * @param data 待序列化对象
     * @return json串
     */
    static toJson<T extends object>(data: T): string {
        if (!data) {
            return '';
        }
        return JSON.stringify(data);
    }

    /**
     * 反序列化json字串到对象
     *
     * @param clazz 构造
     * @param json json串
     * @return 目标对象
     */
    static parse<T extends Serializable>(clazz: ClassCtor<T>, json: string, ...args: AnyType[]): T | undefined {
        try {
            let oriObj: object = JSON.parse(json);
            if (!oriObj) {
                return undefined;
            }
            let result: T = createClazz(clazz, ...args);
            result.deserialize(oriObj);
            return result;
        } catch (err) {
            return undefined;
        }
    }
}