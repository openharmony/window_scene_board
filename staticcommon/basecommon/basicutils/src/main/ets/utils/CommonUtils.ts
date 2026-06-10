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
import { CheckEmptyUtils } from './CheckEmptyUtils';

import { Equality } from './Equality';
import { LogDomain, LogHelper } from './LogHelper';

type AnyType = string | boolean | number | bigint | null | object | undefined;
const RECT_KEY_LEFT: string = 'left';
const RECT_KEY_TOP: string = 'top';
const RECT_KEY_WIDTH: string = 'width';
const RECT_KEY_HEIGHT: string = 'height';

/**
 * Rect接口
 */
export interface Rect {
    left: number;
    top: number;
    width: number;
    height: number;
}

/**
 * 默认rect
 */
const DEFAULT_RECT: Rect = {
    left: 0,
    top: 0,
    width: 0,
    height: 0
}

const TAG = 'CommonUtils';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 常用工具
 *
 * @since 2022-10-13
 */
export class CommonUtils {
    /**
     * 判断对象是否不可用
     *
     * @param obj 待判断对象
     * @return true不可用
     */
    static isInvalid<T>(obj: AnyType | T): boolean {
        // 判断null会包含undefined
        return obj == null;
    }

    /**
     * 判断对象是否可用
     *
     * @param obj 待判断对象
     * @return true可用
     */
    public static isValid<T>(obj: AnyType | T): boolean {
        return !CommonUtils.isInvalid(obj);
    }

    /**
     * 字串判空
     *
     * @param str 字串
     */
    static isEmpty(str: string | String | undefined): boolean {
        if (str === undefined || str === null) {
            return true;
        }
        if (typeof str === 'string' || str instanceof String) {
            return !str.trim();
        }
        return false;
    }

    /**
     * 容器对象判空
     */
    static containerIsEmpty<T>(container: Array<T> | undefined): boolean {
        return container == null || container.length === 0;
    }

    /**
     * 判断是否为number类型
     *
     * @param val 数值
     */
    static isNumber<T>(val: AnyType | T): boolean {
        if (val instanceof Number) {
            return true;
        }
        return (typeof val) === 'number';
    }

    /**
     * 判断是否为boolean类型
     *
     * @param val 数值
     */
    static isBoolean(val: AnyType): boolean {
        if (val instanceof Boolean) {
            return true;
        }
        return (typeof val) === 'boolean';
    }

    /**
     * 判断是否为string类型
     *
     * @param val 数值
     */
    static isString(val: AnyType): boolean {
        if (val instanceof String) {
            return true;
        }
        return (typeof val) === 'string';
    }

    /**
     * 拼接px字串
     *
     * @param val 属性值
     * @return px字串
     */
    static splicePx(val: number): string {
        return val + 'px';
    }

    /**
     * 拼接vp字串
     *
     * @param val 属性值
     * @return vp字串
     */
    static spliceVp(val: number): string {
        return val + 'vp';
    }

    /**
     * 判断相等
     *
     * @param oriObj 原对象
     * @param other 待比较对象
     */
    static equals<T>(oriObj: AnyType | T, other: AnyType | T): boolean {
        if (CommonUtils.isTypeEquality(oriObj)) {
            return (oriObj as Equality).equals(other as Equality);
        }
        // number比较相等
        if (oriObj && other && CommonUtils.isNumber(oriObj) && CommonUtils.isNumber(other)) {
            return Math.abs((oriObj as number) - (other as number)) < Number.EPSILON;
        }
        return oriObj === other;
    }

    /**
     * 判断Equality接口类型
     *
     * @param obj 待判断对象
     */
    static isTypeEquality<T>(obj: AnyType | T): boolean {
        if (CommonUtils.isInvalid(obj)) {
            return false;
        }
        return typeof (obj as Equality).equals === 'function';
    }

    /**
     * rect是否无有效值
     *
     * @param rect rect
     * @return true无效
     */
    static isInvalidRect<T>(rect: Rect | T | undefined): boolean {
        return CommonUtils.isInvalid(rect) || CommonUtils.equalsRect(rect, DEFAULT_RECT);
    }

    /**
     * 判断Rect相等
     *
     * @param oriRect ori Rect
     * @param other other Rect
     */
    static equalsRect<T>(oriRect: Rect | T | undefined, other: Rect | T): boolean {
        oriRect = CommonUtils.getRect(oriRect);
        other = CommonUtils.getRect(other);
        return (oriRect.top === other.top &&
                oriRect.left === other.left &&
                oriRect.width === other.width &&
                oriRect.height === other.height);
    }

    /**
     * 防抖函数
     * @param fn 函数
     * @param time 防抖时间
     * @returns
     */
    static debounce<T extends (...args: Object[]) => void>(fn: T, time: number): T {
        let timerId: number | undefined;
        const newFn = (...args: Object[]): void => {
            if (timerId !== undefined) {
                clearTimeout(timerId);
            }
            timerId = setTimeout(() => {
                timerId = undefined;
                fn(...args);
            }, time);
        };
        return newFn as T;
    }

    /**
     * 获取统一rect，判空处理
     *
     * @param rect rect
     */
    private static getRect<T>(rect: T | undefined): Rect {
        if (CommonUtils.isInvalid(rect)) {
            return DEFAULT_RECT;
        }
        let objContents: [string, number][] | undefined = rect && Object.entries(rect);
        if (objContents) {
            let newRect: Rect = {
                left: 0,
                top: 0,
                width: 0,
                height: 0
            };
            objContents.forEach((value: [string, number]) => {
                if (value[0] === RECT_KEY_LEFT) {
                    newRect.left = value[1];
                } else if (value[0] === RECT_KEY_TOP) {
                    newRect.top = value[1];
                } else if (value[0] === RECT_KEY_WIDTH) {
                    newRect.width = value[1];
                } else if (value[0] === RECT_KEY_HEIGHT) {
                    newRect.height = value[1];
                }
            })
            return newRect;
        }
        return DEFAULT_RECT;
    }

    /**
     * json字符串转map对象
     *
     * @param jsonStr json字符串
     */
    public static jsonStrToMap(jsonStr: string | undefined): Map<string, Object> {
        let result: Map<string, Object> = new Map();
        if (CheckEmptyUtils.isEmpty(jsonStr)) {
            return result;
        }
        try {
            let jsonObject: Object = JSON.parse(jsonStr as string);
            const keys: string[] = Object.keys(jsonObject);
            for (const key of keys) {
                const value: Object = Reflect.get(jsonObject, key);
                result.set(key, value);
            }
        } catch (error) {
            log.showError('parse obj error : %{public}s', error?.message);
        }
        return result;
    }

    public static async sleep(delay: number): Promise<void> {
        return new Promise((resolve) => setTimeout(resolve, delay));
    }

    /**
     * map对象转json字符串
     *
     * @param map
     */
    public static mapToJonStr(map: Map<string, Object>): string {
        try {
            const obj: Record<string, Object> = {};
            map.forEach((value, key) => {
                Reflect.set(obj, key, value);
            });
            return JSON.stringify(obj);
        } catch (error) {
            log.showError('parse map to string error : %{public}s', error?.message);
            return '';
        }
    }

    /**
     * map转对象，提供给atkTs使用，替代Object.fromEntries方法
     *
     * @param jsonStr json字符串
     */
    public static mapToObject(map: Map<string, Object>): Record<string, Object> {
        let obj: Record<string, Object> = {};
        map.forEach((value, key) => {
            if (key !== undefined && key !== null) {
                obj[key] = value;
            }
        });
        return obj;
    }

    /**
     * map对象转json字符串
     *
     * @param map
     */
    public static mapToJsonStr(map: Map<string, Object>): string {
        try {
            const obj: Record<string, Object> = {};
            map.forEach((value, key) => {
                Reflect.set(obj, key, value);
            });
            return JSON.stringify(obj);
        } catch (error) {
            log.showError('parse map to string error : %{public}s', error?.message);
            return '';
        }
    }

    /**
     * json字符串转mapRecord对象
     *
     * @param jsonStr json字符串
     */
    public static jsonStrToMapRecord(jsonStr: string): Map<string, Record<string, Object>> {
        let result: Map<string, Record<string, Object>> = new Map();
        if (CheckEmptyUtils.isEmpty(jsonStr)) {
            return result;
        }
        try {
            let jsonObject = JSON.parse(jsonStr) as Record<string, Record<string, Object>>;
            for (let k of Object.keys(jsonObject)) {
                result.set(k, jsonObject[k]);
            }
        } catch (error) {
            log.showError('parse obj error : %{public}s', error?.message);
        }
        return result;
    }
}