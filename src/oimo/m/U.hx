package oimo.m;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Field;
import haxe.macro.Type;
import oimo.m.IMat3;
import oimo.m.IVec3;
using oimo.m.U;
using haxe.macro.ExprTools;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;

#if macro

/**
 * Macro Utils
 */
class U {

	public static function vec3Names(base:String) {
		return appendSuffixes(base, ["X", "Y", "Z"]);
	}

	public static function mat3Names(base:String) {
		return appendSuffixes(base, [ for (i in 0...3) for (j in 0...3) "" + i + j ]);
	}

	public static function quatNames(base:String) {
		return appendSuffixes(base, ["X", "Y", "Z", "W"]);
	}

	public static function quatVecNames(base:String) {
		return appendSuffixes(base, ["X", "Y", "Z"]);
	}

	public static function quatRealName(base:String) {
		return base + "W";
	}

	public static function mat3NamesDiag(base:String) {
		var m:Array<String> = mat3Names(base);
		return [m[0], m[4], m[8]];
	}

	public static function appendSuffixes(base:String, suffixes:Array<String>) {
		return suffixes.map(function(s) {
			return base + s;
		});
	}

	public static function namesE(e:Expr):Array<String> {
		if (e == null) return null;
		return names(e.s(), e.t());
	}

	public static function names(s:String, t:Type):Array<String> {
		if (t == null) return null;
		var base:String = s;
		var type:String = t.s1();
		//trace("1");
		if (type == (macro:oimo.m.IVec3).toType().toString()) return vec3Names(base);
		//trace("2");
		if (type == (macro:oimo.m.IMat3).toType().toString()) return mat3Names(base);
		//trace("3");
		if (type == (macro:oimo.m.IQuat).toType().toString()) return quatNames(base);
		//trace("4");
		return null;
	}

	public static function e(s:String):Expr {
		return Context.parse(s, Context.currentPos());
	}

	public static function s(e:Expr):String {
		return e.toString();
	}

	public static function t(e:Expr):Type {
		return Context.typeof(e);
	}

	public static function s1(t:Type):String {
		return t.toString();
	}

	public static function pushVariables(fields:Array<Field>, names:Array<String>, kind:ComplexType, ?meta:Metadata, access:Array<Access>) {
		if (meta == null) meta = [];

		for (name in names) {
			fields.push({
				name: name,
				kind: FVar(kind),
				access: access,
				meta: meta,
				pos: pos()
			});
		}
		return fields;
	}

	public static function pos() {
		return Context.currentPos();
	}

	public static function fields() {
		return Context.getBuildFields();
	}

}

#end
