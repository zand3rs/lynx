package controllers

import (
  "github.com/revel/revel"
)

type V1 struct {
  *revel.Controller
}

type Stuff struct {
  Foo string `json:"foo"`
  Bar int
}

func (c V1) Index() revel.Result {
  data := make(map[string]interface{})
  data["error"] = nil
  data["camelCase"] = nil
  stuff := Stuff{Foo: "xyz", Bar: 999}
  data["stuff"] = stuff
  return c.RenderJSON(data)
}
